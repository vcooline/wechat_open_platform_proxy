module WechatOpenPlatformProxy
  class OfficialAccountCustomerServiceMessageJob < ApplicationJob
    queue_as :default

    def perform(official_account_id:, message_params: {})
      OfficialAccount.find_by(id: official_account_id)&.then do |official_account|
        OfficialAccountCustomerServiceMessageService.new(official_account).send_message message_params
      end
    end
  end
end
