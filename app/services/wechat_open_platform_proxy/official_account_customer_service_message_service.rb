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

    def set_typing(open_id:)
      message_params = { touser: open_id, command: "Typing" }
      Rails.logger.info "#{self.class.name} set typing reqt: #{JSON.dump(message_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/custom/typing?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", JSON.dump(message_params)
      Rails.logger.info "#{self.class.name} set typing resp: #{resp.body.squish}"

      JSON.parse(resp.body)["errcode"]&.zero?
    end

    def cancel_typing(open_id:)
      message_params = { touser: open_id, command: "CancelTyping" }
      Rails.logger.info "#{self.class.name} cancel typing reqt: #{JSON.dump(message_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/custom/typing?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", JSON.dump(message_params)
      Rails.logger.info "#{self.class.name} cancel typing resp: #{resp.body.squish}"

      JSON.parse(resp.body)["errcode"]&.zero?
    end
  end
end
