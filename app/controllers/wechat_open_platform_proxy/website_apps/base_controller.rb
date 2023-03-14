module WechatOpenPlatformProxy
  class WebsiteApps::BaseController < ApplicationController
    before_action :set_website_app

    private

      def set_website_app
        @website_app = WebsiteApp.find_by!(app_id: params[:website_app_app_id])
      end
  end
end
