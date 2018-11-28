require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::MessagesController < OfficialAccounts::BaseController
    def create
      message_body = request.body.tap(&:rewind ).read
      reply_body = OfficialAccountMessageHandler.new(@official_account).perform(message_body, params)
      logger.info "OfficialAccountMessageHandler reply body: #{reply_body}"
      reply_body.present? ? render(xml: ThirdPartyPlatformMessageEncryptor.new(@third_party_platform).encrypt_message(reply_body)) : render(plain: "")
    rescue => e
      logger.error "WechatOpenPlatformProxy::OfficialAccounts::MessagesController #{e.class.name}: #{e.message}"
      render plain: ""
    end
  end
end
