module WechatOpenPlatformProxy
  module SnapshotUserGuard
    extend ActiveSupport::Concern

    included do
      rescue_from WechatUserAuthorizeService::SnapshotUserError, with: :deny_snapshot_user
    end

    module ClassMethods
    end

    private

      def deny_snapshot_user
        respond_to do |format|
          format.html { redirect_to welcome_snapshot_user_path, status: :temporary_redirect }
          format.json { render json: {error: {message: "Wechat snapshot user not allowed."}}, status: :forbidden }
        end
      end
  end
end
