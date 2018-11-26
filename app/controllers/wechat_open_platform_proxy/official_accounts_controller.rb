require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccountsController < ApplicationController
    before_action :set_third_party_platform
    before_action :set_official_account, only: [:show]

    def index
      @official_accounts = @third_party_platform.official_accounts.page(params[:page]).per(params[:per] || 10)
    end

    def show
      @official_account = OfficialAccountAuthorizeService.new(@third_party_platform).refresh_account_info(@official_account.app_id) if params[:force_refresh].present?
    rescue AuthorizationInfoApiError => e
      render json: JSON.load(e.message), status: :unauthorized
    end

    private
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find_by!(uid: params[:third_party_platform_uid])
      end

      def set_official_account
        @official_account = @third_party_platform.official_accounts.find_or_initialize_by(app_id: params[:app_id])
      end
  end
end
