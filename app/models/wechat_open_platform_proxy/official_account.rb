module WechatOpenPlatformProxy
  class OfficialAccount < ApplicationRecord
    belongs_to :third_party_platform

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

  end
end