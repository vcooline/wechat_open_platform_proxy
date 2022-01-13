module WechatOpenPlatformProxy
  class OfficialAccountOpenBindJob < ApplicationJob
    queue_as :low

    def perform(official_account_id)
      official_account = OfficialAccount.find official_account_id
      OfficialAccountOpenBindService.new(official_account).bind
    end
  end
end
