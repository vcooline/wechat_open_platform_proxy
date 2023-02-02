module WechatOpenPlatformProxy
  class ThirdPartyPlatformMessageEncryptor
    InvalidMessageSignatureError = Class.new StandardError

    attr_reader :third_party_platform

    def initialize(platform)
      @third_party_platform = platform
    end

    def decrypt_message(original_xml, timestamp, nonce, msg_signature)
      verify_message(original_xml, timestamp, nonce, msg_signature)
      WechatMessageEncryptor.decrypt_message(original_xml, third_party_platform.message_encryption_key)
    end

    def encrypt_message(original_xml)
      WechatMessageEncryptor.encrypt_message(original_xml, third_party_platform.messages_checking_token, third_party_platform.message_encryption_key, third_party_platform.app_id)
    end

    private

      def verify_message(original_xml, timestamp, nonce, msg_signature)
        msg_encrypt = Hash.from_xml(original_xml)["xml"]["Encrypt"]
        raise InvalidMessageSignatureError unless Digest::SHA1.hexdigest([third_party_platform.messages_checking_token, timestamp, nonce, msg_encrypt].sort.join).eql?(msg_signature)
      end
  end
end
