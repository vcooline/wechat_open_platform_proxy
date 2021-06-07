module WechatOpenPlatformProxy
  class OpenAccount < ApplicationRecord
    belongs_to :third_party_platform
    has_many :official_accounts, dependent: nil

    validates_presence_of :third_party_platform_id
    validates :app_id, presence: true, uniqueness: true
    validates :principal_name, presence: true, uniqueness: true

    def to_param
      app_id
    end

    def to_s
      principal_name
    end
  end
end
