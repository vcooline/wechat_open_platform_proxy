module WechatOpenPlatformProxy
  class OfficialAccount < ApplicationRecord
    has_one_attached :qrcode

    belongs_to :third_party_platform
    belongs_to :open_account, optional: true
    has_one :message_handler, dependent: :destroy

    validates :app_id, uniqueness: { scope: :third_party_platform, allow_nil: false }
    validates :original_id, uniqueness: { scope: :third_party_platform, allow_nil: true }

    scope :official_account, -> { where(mini_program_info: nil) }
    scope :mini_program, -> { where.not(mini_program_info: nil) }

    after_commit :bind_open_account, on: :create

    def to_param
      app_id
    end

    def to_s
      nick_name || app_id || original_id
    end

    def mini_program?
      mini_program_info.present?
    end
    alias_method :is_mini_program?, :mini_program?

    def allow_oauth?
      service_type_info&.dig("id").eql?(2) && verify_type_info&.dig("id").eql?(0)
    end

    def allow_open_bind?
      Array(func_info).detect { |fun| Hash(fun).dig("funcscope_category", "id").eql?(24) }.present?
    end

    def open_app_id
      open_account&.app_id
    end

    def access_token(force_renew: false)
      OfficialAccountCacheStore.new(self).fetch_access_token(force_renew:)
    end

    private

      def bind_open_account
        OfficialAccountOpenBindJob.perform_later(self.id) if allow_open_bind?
      end
  end
end
