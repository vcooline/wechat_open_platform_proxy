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

    def card_sign(options = {})
      wx_card_ticket = OfficialAccountCacheStore.new(official_account).fetch_wx_card_ticket
      Digest::SHA1.hexdigest([wx_card_ticket, *options.values].map(&:to_s).sort.join)
    end

    # 签名说明
    # 1.将 api_ticket、timestamp、card_id、code、openid、nonce_str的value值进行字符串的字典序排序。
    # 2.将所有参数字符串拼接成一个字符串进行sha1加密，得到signature。
    # 3.signature中的timestamp，nonce字段和card_ext中的timestamp，nonce_str字段必须保持一致。
    def card_ext_config(card_id:, code:, openid:)
      {
        code:,
        openid:,
        timestamp: Time.now.to_i,
        nonce_str: SecureRandom.base58
      }.tap { |conf| conf.merge!(signature: card_sign(timestamp: conf[:timestamp], card_id:, code:, openid:, nonce_str: conf[:nonce_str])) }
    end
  end
end
