module WechatOpenPlatformProxy
  class OfficialAccountMessageHandler
    attr_reader :official_account, :third_party_platform

    def initialize(official_account)
      @official_account = official_account
      @third_party_platform = official_account.third_party_platform
    end

    def perform(message_body, params)
      Rails.logger.info "OfficialAccountMessageHandler message body:\n#{message_body}"
      message_params = ThirdPartyPlatformMessageEncryptor.new(third_party_platform).decrypt_message(message_body, params[:timestamp], params[:nonce], params[:msg_signature])
      Rails.logger.info "OfficialAccountMessageHandler message params: #{message_params.to_json}"
    end
  end
end
