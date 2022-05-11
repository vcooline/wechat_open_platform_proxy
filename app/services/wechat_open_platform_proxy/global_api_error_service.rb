module WechatOpenPlatformProxy
  class GlobalApiErrorService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def perform(resp)
      resp_info = JSON.load(resp.body).to_h

      if resp_info["errcode"] == 40001
        OfficialAccountCacheStore.new(official_account).fetch_access_token(force_renew: true)
      end
    end
  end
end
