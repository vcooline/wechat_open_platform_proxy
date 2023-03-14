module WechatOpenPlatformProxy
  class WebsiteApps::WechatUserAuthorizationsController < WebsiteApps::BaseController
    before_action :check_code_granted, only: [:show]

    def new
      redirect_url = params[:redirect_url].presence # || request.referer
      query_params = {
        appid: ENVConfig.wechat_oauth_website_app_app_id,
        redirect_uri: website_app_wechat_user_authorization_url(@website_app.app_id, redirect_url:, host: (ENVConfig.wechat_oauth_base_url || request.host)),
        response_type: "code",
        scope: "snsapi_login"
      }
      redirect_to "https://open.weixin.qq.com/connect/qrconnect?#{query_params.to_query}#wechat_redirect", allow_other_host: true
    end

    def show
      @authorized_info = WebsiteUserAuthorizeService.new(@website_app).get_authorized_info(params[:code])
      if params[:redirect_url].present?
        redirect_to url_with_additional_params(params[:redirect_url], wechat_website_code: params[:code], wechat_website_app_id: @website_app.app_id), allow_other_host: true
      else
        render :show
      end
    end

    private

      def check_code_granted
        return if params[:code].present?

        logger.error "#{self.class.name} #{self.action_name} authorize failed: #{params.to_json}"
        redirect_to root_path(message: "授权登录失败，请稍候重试...")
      end
  end
end
