module WechatOpenPlatformProxy
  class OfficialAccount < ApplicationRecord
    belongs_to :third_party_platform
    belongs_to :open_account, optional: true
    has_one :message_handler, dependent: :destroy

    validates_uniqueness_of :app_id, scope: :third_party_platform, allow_nil: false
    validates_uniqueness_of :original_id, scope: :third_party_platform, allow_nil: true

    scope :mini_program, -> { where.not(mini_program_info: nil) }

    def to_param
      app_id
    end

    def to_s
      nick_name || app_id || original_id
    end

    def is_mini_program?
      mini_program_info.present?
    end

    def allow_oauth?
      service_type_info&.dig("id").eql?(2) && verify_type_info&.dig("id").eql?(0)
    end

    def allow_open_bind?
      Array(func_info).detect{ |fun| Hash(fun).dig("funcscope_category", "id").eql?(24) }.present?
    end

    def open_app_id
      open_account&.app_id
    end

    def access_token(force_renew = false)
      OfficialAccountCacheStore.new(self).fetch_access_token(force_renew)
    end
  end
end
