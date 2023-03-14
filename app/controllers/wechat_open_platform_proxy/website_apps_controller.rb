module WechatOpenPlatformProxy
  class WebsiteAppsController < ApplicationController
    before_action :set_website_app, only: %i[show]

    def show; end

    private

      def set_website_app
        @website_app = WebsiteApp.find_by!(app_id: params[:app_id])
      end
  end
end
