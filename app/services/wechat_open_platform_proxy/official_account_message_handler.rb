module WechatOpenPlatformProxy
  class OfficialAccountMessageHandler
    attr_reader :official_account, :third_party_platform

    def initialize(official_account)
      @official_account = official_account
      @third_party_platform = official_account.third_party_platform
    end

    def perform(message_body, params)
      Rails.logger.info "OfficialAccountMessageHandler message body:\n#{message_body}"
      message_params = Hash.from_xml(ThirdPartyPlatformMessageEncryptor.new(third_party_platform).decrypt_message(message_body, params[:timestamp], params[:nonce], params[:msg_signature]))["xml"]
      Rails.logger.info "OfficialAccountMessageHandler message params: #{message_params.to_json}"

      if official_account.app_id == ENVConfig.wechat_open_platform_test_official_account_app_id
        TestOfficialAccountMessageHandler.new(official_account).handle_official_account_message(message_params)
      elsif official_account.app_id == ENVConfig.wechat_open_platform_test_mini_program_app_id
        TestOfficialAccountMessageHandler.new(official_account).handle_mini_program_message(message_params)
      else
        handle_real_message(message_params)
      end
    end

    private
      def handle_real_message(message_params)
        (official_account.message_handler&.name || ENVConfig.wechat_open_platform_default_message_handler_name)&.classify&.safe_constantize&.perform(message_params)
      end
  end
end
