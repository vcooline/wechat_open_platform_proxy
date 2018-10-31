require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class ThirdPartyPlatformsController < ApplicationController
    before_action :set_third_party_platform, only: [:show]

    def index
      @third_party_platforms = ThirdPartyPlatform.all
    end

    def show
    end

    private
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:uid])
      end
  end
end
