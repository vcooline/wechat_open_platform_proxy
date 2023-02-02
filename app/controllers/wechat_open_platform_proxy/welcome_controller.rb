module WechatOpenPlatformProxy
  class WelcomeController < ApplicationController
    def index; end

    def snapshot_user
      render layout: false
    end

    def verify_file
      render plain: VerifyFile.find_by(name: params[:wechat_open_platform_verify_file])&.content
    end
  end
end
