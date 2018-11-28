module WechatOpenPlatformProxy
  class MessageHandler < ApplicationRecord
    belongs_to :official_account

    validates :official_account, presence: true, uniqueness: true
    validates_presence_of :name
  end
end
