module WechatOpenPlatformProxy
  class WebsiteApp < ApplicationRecord
    validates :app_id, presence: true, uniqueness: true
    validates :app_secret, presence: true
  end
end
