module WechatOpenPlatformProxy
  class ThirdPartyPlatforms::AuthorizationEventsController < ApplicationController
    before_action :set_third_party_platform

    def create
      message_body = request.body.tap(&:rewind).read
      ThirdPartyPlatformAuthorizationEventHandler.new(@third_party_platform).perform(message_body, params)
      render plain: "success"
    end

    private

      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end
  end
end
