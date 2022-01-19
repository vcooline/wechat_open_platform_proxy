require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccountAuthorizationsController < ApplicationController
    before_action :set_third_party_platform
    after_action :delete_pre_auth_code, only: [:show]

    def new
      redirect_url = params[:redirect_url] || request.referrer
      authorize_params = {
        component_appid: @third_party_platform.app_id,
        pre_auth_code: ThirdPartyPlatformCacheStore.new(@third_party_platform).fetch_pre_auth_code(params[:force_renew].presence),
        redirect_uri: third_party_platform_official_account_authorization_url(@third_party_platform, redirect_url: redirect_url),
        auth_type: params[:auth_type].presence || 3
      }
      @authorize_url = "https://mp.weixin.qq.com/cgi-bin/componentloginpage?#{authorize_params.to_query}#wechat_redirect"
      render layout: false
    end

    def show
      if params[:auth_code].present?
        redirect_url = params[:redirect_url].present? ?
          url_with_additional_params(params[:redirect_url], wechat_open_auth_code: params[:auth_code], wechat_open_expires_in: params[:expires_in]) :
          account_info_third_party_platform_official_account_authorization_path(@third_party_platform, auth_code: params[:auth_code])
        redirect_to redirect_url, allow_other_host: true
      else
        logger.error "OfficialAccount authorize failed with callback params: #{params.to_json}"
        render plain: "授权失败，请稍候重试..."
      end
    end

    def account_info
      @official_account = OfficialAccountAuthorizeService.new(@third_party_platform).get_account_info(params[:auth_code])
    end

    private
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def delete_pre_auth_code
        ThirdPartyPlatformCacheStore.new(@third_party_platform).delete_pre_auth_code
      end
  end
end
