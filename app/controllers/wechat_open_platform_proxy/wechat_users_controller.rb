require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class WechatUsersController < ApplicationController
    before_action :set_wechat_user, only: [:show, :edit, :update, :destroy]

    # GET /wechat_users
    def index
      @wechat_users = WechatUser.all
    end

    # GET /wechat_users/1
    def show
    end

    # GET /wechat_users/new
    def new
      @wechat_user = WechatUser.new
    end

    # GET /wechat_users/1/edit
    def edit
    end

    # POST /wechat_users
    def create
      @wechat_user = WechatUser.new(wechat_user_params)

      if @wechat_user.save
        redirect_to @wechat_user, notice: 'Wechat user was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /wechat_users/1
    def update
      if @wechat_user.update(wechat_user_params)
        redirect_to @wechat_user, notice: 'Wechat user was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /wechat_users/1
    def destroy
      @wechat_user.destroy
      redirect_to wechat_users_url, notice: 'Wechat user was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_wechat_user
        @wechat_user = WechatUser.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def wechat_user_params
        params.fetch(:wechat_user, {})
      end
  end
end
