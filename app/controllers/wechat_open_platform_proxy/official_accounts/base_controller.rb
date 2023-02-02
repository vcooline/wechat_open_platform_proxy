module WechatOpenPlatformProxy
  class OfficialAccounts::BaseController < ApplicationController
    before_action :set_third_party_platform, :set_official_account

    private

      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def set_official_account
        @official_account = @third_party_platform.official_accounts.find_or_initialize_by(app_id: params[:official_account_app_id]).tap do |account|
          OfficialAccountAuthorizeService.new(@third_party_platform).refresh_account_info(account.app_id) if account.new_record? && [ENVConfig.wechat_open_platform_test_official_account_app_id, ENVConfig.wechat_open_platform_test_mini_program_app_id].exclude?(account.app_id)
        end
      end
  end
end
