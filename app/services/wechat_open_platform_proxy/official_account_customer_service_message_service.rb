module WechatOpenPlatformProxy
  class OfficialAccountCustomerServiceMessageService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def send_message(message_params)
      Rails.logger.info "OfficialAccountCustomerServiceMessageService send_message reqt:\n#{message_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", message_params.to_json
      Rails.logger.info "OfficialAccountCustomerServiceMessageService send_message resp: #{resp.body}"

      resp
    end
  end
end
