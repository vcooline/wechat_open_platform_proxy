module WechatOpenPlatformProxy
  class WechatUserAuthorizationsController < ApplicationController
    before_action :set_third_party_platform, :set_official_account

    def new
      redirect_url = params[:redirect_url] || request.referer
      authorize_params = {
        component_appid: @third_party_platform.app_id,
        appid: @official_account.app_id,
        redirect_uri: third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account, scope: params[:scope], redirect_url:),
        response_type: "code",
        scope: params[:scope].presence || "snsapi_base", # snsapi_userinfo
        state: params[:state]
      }
      redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?#{URI.encode_www_form(authorize_params)}#wechat_redirect", allow_other_host: true
    end

    def show
      fallback_redirect_url = if params[:scope] == "snsapi_userinfo"
                                user_info_third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account)
                              else
                                base_info_third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account)
                              end
      if params[:code].present?
        redirect_to url_with_additional_params((params[:redirect_url].presence || fallback_redirect_url), wechat_oauth_code: params[:code], wechat_oauth_scope: params[:scope]), allow_other_host: true
      else
        logger.error "WechatUser authorize failed with callback params: #{params.to_json}"
        render plain: "授权登录失败，请稍候重试..."
      end
    end

    def create
      scope = authorization_params[:scope].presence || params[:scope].presence || "snsapi_base"
      code = authorization_params[:code].presence || params[:code]
      wechat_user_info = WechatUserAuthorizeService.new(@official_account).get_authorized_info(code, scope:)

      render json: wechat_user_info
    end

    def base_info
      render json: WechatUserAuthorizeService.new(@official_account).get_base_info(params[:wechat_oauth_code].presence || params[:code])
    end

    def user_info
      render json: WechatUserAuthorizeService.new(@official_account).get_user_info(params[:wechat_oauth_code].presence || params[:code])
    end

    private

      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def set_official_account
        @official_account = @third_party_platform.official_accounts.find_by!(app_id: params[:official_account_app_id])
      end

      def authorization_params
        params.fetch(:wechat_user_authorization, {}).permit(:code, :scope)
      end
  end
end
