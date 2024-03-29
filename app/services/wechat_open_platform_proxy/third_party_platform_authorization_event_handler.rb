module WechatOpenPlatformProxy
  class ThirdPartyPlatformAuthorizationEventHandler
    attr_reader :third_party_platform

    def initialize(platform)
      @third_party_platform = platform
    end

    def perform(message_body, params)
      Rails.logger.info "ThirdPartyPlatformAuthorizationEventHandler message body: #{message_body.squish}"
      message_params = Hash.from_xml(ThirdPartyPlatformMessageEncryptor.new(third_party_platform).decrypt_message(message_body, params[:timestamp], params[:nonce], params[:msg_signature]))["xml"]
      Rails.logger.info "ThirdPartyPlatformAuthorizationEventHandler message params: #{message_params.to_json}"

      case message_params["InfoType"]
      when "component_verify_ticket"
        ThirdPartyPlatformCacheStore.new(third_party_platform).write_component_verify_ticket(message_params["ComponentVerifyTicket"])
      when "unauthorized"
        OfficialAccount.find_by(app_id: message_params["AuthorizerAppid"])&.destroy
      end
    end
  end
end
