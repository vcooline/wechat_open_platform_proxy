module WechatOpenPlatformProxy
  class ThirdPartyPlatform < ApplicationRecord
    has_many :official_accounts

    validates :uid, :app_id, :app_secret, presence: true, uniqueness: true
    validates_presence_of :messages_checking_token, :message_encryption_key

    def to_param
      uid
    end
  end
end
