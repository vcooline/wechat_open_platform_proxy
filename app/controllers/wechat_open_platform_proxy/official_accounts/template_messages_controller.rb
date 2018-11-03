require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::TemplateMessagesController < OfficialAccounts::BaseController
    def create
      resp = OfficialAccountTemplateMessageService.new(@official_account).send_message(template_message_params)
      render json: JSON.load(resp.body), status: resp.status
    end

    private
      def template_message_params
        params.fetch(:template_message, {}).permit!
      end
  end
end
