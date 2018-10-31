require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccountsController < ApplicationController
    before_action :set_official_account, only: [:show, :edit, :update, :destroy]

    # GET /official_accounts
    def index
      @official_accounts = OfficialAccount.all
    end

    # GET /official_accounts/1
    def show
    end

    # GET /official_accounts/new
    def new
      @official_account = OfficialAccount.new
    end

    # GET /official_accounts/1/edit
    def edit
    end

    # POST /official_accounts
    def create
      @official_account = OfficialAccount.new(official_account_params)

      if @official_account.save
        redirect_to @official_account, notice: 'Official account was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /official_accounts/1
    def update
      if @official_account.update(official_account_params)
        redirect_to @official_account, notice: 'Official account was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /official_accounts/1
    def destroy
      @official_account.destroy
      redirect_to official_accounts_url, notice: 'Official account was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_official_account
        @official_account = OfficialAccount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def official_account_params
        params.fetch(:official_account, {})
      end
  end
end
