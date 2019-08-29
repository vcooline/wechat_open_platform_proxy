module WechatOpenPlatformProxy
  class GlobalApiErrorService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def perform(resp)
      if resp["errcode"] == 40001
        OfficialAccountCacheStore.new(official_account).fetch_access_token(true)
      end
    end
  end
end
