require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class WechatUserAuthorizationsController < ApplicationController
    before_action :set_third_party_platform, :set_official_account

    def new
      redirect_url = params[:redirect_url] || request.referrer
      authorize_params = {
        component_appid: @third_party_platform.app_id,
        appid: @official_account.app_id,
        redirect_uri: third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account, scope: params[:scope], redirect_url: redirect_url),
        response_type: "code",
        scope: params[:scope].presence || "snsapi_base", # snsapi_userinfo
        state: params[:state]
      }
      redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?#{URI.encode_www_form(authorize_params)}#wechat_redirect"
    end

    def show
      fallback_redirect_url = (params[:scope] == "snsapi_userinfo") ?
        user_info_third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account) :
        open_id_third_party_platform_official_account_wechat_user_authorization_url(@third_party_platform, @official_account)
      if params[:code].present?
        redirect_to url_with_additional_params((params[:redirect_url].presence || fallback_redirect_url), code: params[:code])
      else
        logger.error "WechatUser authorize failed with callback params: #{params.to_json}"
        render plain: "授权登录失败，请稍候重试..."
      end
    end

    def open_id
      render json: WechatUserAuthorizeService.new(@official_account).get_base_info(params[:code])
    end

    def user_info
      render json: WechatUserAuthorizeService.new(@official_account).get_user_info(params[:code])
    end

    private
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def set_official_account
        @official_account = @third_party_platform.official_accounts.find_by!(app_id: params[:official_account_app_id])
      end
  end
end
