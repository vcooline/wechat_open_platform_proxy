require_dependency "wechat_open_platform_proxy/application_controller"

module WechatOpenPlatformProxy
  class ThirdPartyPlatformsController < ApplicationController
    before_action :set_third_party_platform, only: [:show, :edit, :update, :destroy]

    # GET /third_party_platforms
    def index
      @third_party_platforms = ThirdPartyPlatform.all
    end

    # GET /third_party_platforms/1
    def show
    end

    # GET /third_party_platforms/new
    def new
      @third_party_platform = ThirdPartyPlatform.new
    end

    # GET /third_party_platforms/1/edit
    def edit
    end

    # POST /third_party_platforms
    def create
      @third_party_platform = ThirdPartyPlatform.new(third_party_platform_params)

      if @third_party_platform.save
        redirect_to @third_party_platform, notice: 'Third party platform was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /third_party_platforms/1
    def update
      if @third_party_platform.update(third_party_platform_params)
        redirect_to @third_party_platform, notice: 'Third party platform was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /third_party_platforms/1
    def destroy
      @third_party_platform.destroy
      redirect_to third_party_platforms_url, notice: 'Third party platform was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_third_party_platform
        @third_party_platform = ThirdPartyPlatform.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def third_party_platform_params
        params.fetch(:third_party_platform, {})
      end
  end
end
