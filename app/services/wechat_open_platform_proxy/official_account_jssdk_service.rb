module WechatOpenPlatformProxy
  class OfficialAccountJssdkService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def perform(message_params)
    end
  end
end
