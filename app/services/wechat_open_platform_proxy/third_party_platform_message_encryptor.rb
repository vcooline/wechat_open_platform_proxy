module WechatOpenPlatformProxy
  class ThirdPartyPlatformMessageEncryptor
    InvalidMessageSignatureError = Class.new StandardError

    attr_reader :platform

    def initialize(platform)
      @platform = platform
    end

    def decrypt_message(original_xml, timestamp, nonce, msg_signature)
      verify_message(original_xml, timestamp, nonce, msg_signature)
      WechatMessageEncryptor.decrypt_message(original_xml, platform.message_encryption_key)
    end

    def encrypt_message(original_xml)
    end

    private
      def verify_message(original_xml, timestamp, nonce, msg_signature)
        msg_encrypt = Hash.from_xml(original_xml)["xml"]["Encrypt"]
        raise InvalidMessageSignatureError unless Digest::SHA1.hexdigest([platform.messages_checking_token, timestamp, nonce, msg_encrypt].sort.join).eql?(msg_signature)
      end
  end
end
