module WechatOpenPlatformProxy
  class OfficialAccountJssdkService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def config(url)
      jsapi_ticket = OfficialAccountCacheStore.new(official_account).fetch_jsapi_ticket
      {
        appId: official_account.app_id,
        timestamp: Time.now.to_i,
        nonceStr: SecureRandom.base58
      }.tap { |conf| conf.merge!(signature: Digest::SHA1.hexdigest("jsapi_ticket=#{jsapi_ticket}&noncestr=#{conf[:nonceStr]}&timestamp=#{conf[:timestamp]}&url=#{url}")) }
    end

    def card_sign(card_id:, code:, openid:)
      wx_card_ticket = OfficialAccountCacheStore.new(official_account).fetch_wx_card_ticket
      Digest::SHA1.hexdigest([wx_card_ticket, Time.now.to_i, card_id, code, openid, SecureRandom.base58].map(&:to_s).sort.join)
    end
  end
end
