require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class WelcomeController < ApplicationController
    def index
    end

    def verify_file
      render plain: VerifyFile.find_by(name: params[:wechat_open_platform_verify_file])&.content
    end
  end
end
