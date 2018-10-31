module WechatOpenPlatformProxy
  class OfficialAccount < ApplicationRecord
    belongs_to :third_party_platform

    validates :app_id, presence: true, uniqueness: true
    validates :original_id, uniqueness: true, allow_nil: true

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
