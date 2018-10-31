require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::MessagesController < ApplicationController
    before_action :set_official_accounts_message, only: [:show, :edit, :update, :destroy]

    # GET /official_accounts/messages
    def index
      @official_accounts_messages = OfficialAccounts::Message.all
    end

    # GET /official_accounts/messages/1
    def show
    end

    # GET /official_accounts/messages/new
    def new
      @official_accounts_message = OfficialAccounts::Message.new
    end

    # GET /official_accounts/messages/1/edit
    def edit
    end

    # POST /official_accounts/messages
    def create
      @official_accounts_message = OfficialAccounts::Message.new(official_accounts_message_params)

      if @official_accounts_message.save
        redirect_to @official_accounts_message, notice: 'Message was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /official_accounts/messages/1
    def update
      if @official_accounts_message.update(official_accounts_message_params)
        redirect_to @official_accounts_message, notice: 'Message was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /official_accounts/messages/1
    def destroy
      @official_accounts_message.destroy
      redirect_to official_accounts_messages_url, notice: 'Message was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_official_accounts_message
        @official_accounts_message = OfficialAccounts::Message.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def official_accounts_message_params
        params.fetch(:official_accounts_message, {})
      end
  end
end
