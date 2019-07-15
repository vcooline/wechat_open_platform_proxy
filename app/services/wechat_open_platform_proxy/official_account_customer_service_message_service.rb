module WechatOpenPlatformProxy
  class OfficialAccountCustomerServiceMessageService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def send_message(message_params)
      Rails.logger.info "OfficialAccountCustomerServiceMessageService send_message reqt: #{JSON.dump(message_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", JSON.dump(message_params)
      Rails.logger.info "OfficialAccountCustomerServiceMessageService send_message resp: #{resp.body.squish}"

      resp
    end
  end
end
