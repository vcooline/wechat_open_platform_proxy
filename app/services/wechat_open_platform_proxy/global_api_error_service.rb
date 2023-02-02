module WechatOpenPlatformProxy
  class GlobalApiErrorService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def perform(resp)
      resp_info = JSON.parse(resp.body).to_h

      return unless resp_info["errcode"] == 40001

      OfficialAccountCacheStore.new(official_account).fetch_access_token(force_renew: true)
    end
  end
end
