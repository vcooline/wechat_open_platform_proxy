require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccountsController < ApplicationController
    before_action :set_third_party_platform
    before_action :set_official_account, only: [:show]

    def index
      @official_accounts = @third_party_platform.official_accounts.page(params[:page]).per(params[:per] || 10)
    end

    def show
    end

    private
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def set_official_account
        @official_account = OfficialAccount.find_by!(app_id: params[:app_id])
      end
  end
end
