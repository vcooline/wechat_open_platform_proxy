require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class WechatUserAuthorizationsController < ApplicationController
    before_action :set_wechat_user_authorization, only: [:show, :edit, :update, :destroy]

    # GET /wechat_user_authorizations
    def index
      @wechat_user_authorizations = WechatUserAuthorization.all
    end

    # GET /wechat_user_authorizations/1
    def show
    end

    # GET /wechat_user_authorizations/new
    def new
      @wechat_user_authorization = WechatUserAuthorization.new
    end

    # GET /wechat_user_authorizations/1/edit
    def edit
    end

    # POST /wechat_user_authorizations
    def create
      @wechat_user_authorization = WechatUserAuthorization.new(wechat_user_authorization_params)

      if @wechat_user_authorization.save
        redirect_to @wechat_user_authorization, notice: 'Wechat user authorization was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /wechat_user_authorizations/1
    def update
      if @wechat_user_authorization.update(wechat_user_authorization_params)
        redirect_to @wechat_user_authorization, notice: 'Wechat user authorization was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /wechat_user_authorizations/1
    def destroy
      @wechat_user_authorization.destroy
      redirect_to wechat_user_authorizations_url, notice: 'Wechat user authorization was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_wechat_user_authorization
        @wechat_user_authorization = WechatUserAuthorization.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def wechat_user_authorization_params
        params.fetch(:wechat_user_authorization, {})
      end
  end
end
