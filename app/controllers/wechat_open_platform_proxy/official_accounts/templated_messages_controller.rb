require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::TemplatedMessagesController < OfficialAccounts::BaseController
    before_action :check_remote_ip_whitelisted, only: [:create]

    def create
      resp = OfficialAccountTemplatedMessageService.new(@official_account).send_message(templated_message_params)
      render json: JSON.load(resp.body), status: resp.status
    end

    private
      def templated_message_params
        params.fetch(:templated_message, {}).permit!
      end
  end
end
