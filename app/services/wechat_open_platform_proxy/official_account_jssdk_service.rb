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
  end
end
