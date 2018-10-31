require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class OfficialAccounts::AuthorizationEventsController < ApplicationController
    before_action :set_official_accounts_authorization_event, only: [:show, :edit, :update, :destroy]

    # GET /official_accounts/authorization_events
    def index
      @official_accounts_authorization_events = OfficialAccounts::AuthorizationEvent.all
    end

    # GET /official_accounts/authorization_events/1
    def show
    end

    # GET /official_accounts/authorization_events/new
    def new
      @official_accounts_authorization_event = OfficialAccounts::AuthorizationEvent.new
    end

    # GET /official_accounts/authorization_events/1/edit
    def edit
    end

    # POST /official_accounts/authorization_events
    def create
      @official_accounts_authorization_event = OfficialAccounts::AuthorizationEvent.new(official_accounts_authorization_event_params)

      if @official_accounts_authorization_event.save
        redirect_to @official_accounts_authorization_event, notice: 'Authorization event was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /official_accounts/authorization_events/1
    def update
      if @official_accounts_authorization_event.update(official_accounts_authorization_event_params)
        redirect_to @official_accounts_authorization_event, notice: 'Authorization event was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /official_accounts/authorization_events/1
    def destroy
      @official_accounts_authorization_event.destroy
      redirect_to official_accounts_authorization_events_url, notice: 'Authorization event was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_official_accounts_authorization_event
        @official_accounts_authorization_event = OfficialAccounts::AuthorizationEvent.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def official_accounts_authorization_event_params
        params.fetch(:official_accounts_authorization_event, {})
      end
  end
end
