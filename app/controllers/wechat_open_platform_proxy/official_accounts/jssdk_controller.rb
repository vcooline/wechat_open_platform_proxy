require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::JssdkController < OfficialAccounts::BaseController
    before_action :check_remote_ip_whitelisted, only: [:create]

    def wx_config
      render json: OfficialAccountJssdkService.new(@official_account).config(config_params[:url]), status: :ok
    end

    def card_wx_config
      render json: OfficialAccountJssdkService.new(@official_account).card_ext_config(*card_config_params.values_at(:card_id, :code, :openid)), status: :ok
    end

    def card_sign
      render json: OfficialAccountJssdkService.new(@official_account).card_sign(card_sign_params.to_h), status: :ok
    end

    private
      def config_params
        params.fetch(:config_params, {}).permit(:url)
      end

      def card_config_params
        params.fetch(:card_config_params, {}).permit(:card_id, :code, :openid)
      end

      def card_sign_params
        params.fetch(:card_sign_params, {}).permit(:noncestr, :timestamp, :card_id)
      end
  end
end
