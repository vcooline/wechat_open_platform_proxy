module WechatOpenPlatformProxy
  module AuthGuard
    extend ActiveSupport::Concern
    InvalidAuthTypeError = Class.new(StandardError)
    InvalidAuthValueError = Class.new(StandardError)
    NotAllowedRemoteIpError = Class.new(StandardError)
    AuthenticateFailError = Class.new(StandardError)

    SupportedAuthTypes = ["PlainUserToken", "PlainClientToken"].freeze
    UrlAuthTypeMappings = { auth_token: "PlainClientToken" }.freeze

    included do
      rescue_from AuthenticateFailError, with: :handle_auth_failure
      rescue_from NotAllowedRemoteIpError, with: :handle_remote_ip_not_allowed
    end

    module ClassMethods
    end

    private

      def authenticate_client
        send("authenticate_client_using_#{auth_params[:type].underscore}", auth_params[:value])
      rescue => e
        logger.error "#{e.class.name}: #{e.message}"
        raise AuthenticateFailError, "#{e.class.name}: #{e.message}"
      end

      def authenticate_client_using_plain_client_token(token_value)
        raise InvalidAuthValueError unless token_value == ENVConfig.client_auth_token
      end

      def auth_params
        @auth_params ||= auth_params_from_header || auth_params_from_url
      end

      def auth_params_from_header
        return if request.authorization.blank?

        HashWithIndifferentAccess.new.tap { |p| p[:type], p[:value] = request.authorization&.split }.tap do |p|
          raise(InvalidAuthTypeError, "auth type not supported.") if SupportedAuthTypes.exclude?(p[:type])
          raise(InvalidAuthValueError, "auth value is blank.") if p[:value].blank?
        end
      end

      def auth_params_from_url
        UrlAuthTypeMappings.each do |original_type, type|
          return { type:, value: params[original_type] } if params[original_type].present?
        end
        nil
      end

      def check_remote_ip_whitelisted
        return if request.remote_ip.in?(ENVConfig.remote_ip_whitelist.to_s.split(","))

        logger.error "remote ip not in whitelist: #{request.remote_ip}"
        raise NotAllowedRemoteIpError, "remote ip not in whitelist: #{request.remote_ip}"
      end

      def handle_auth_failure
        respond_to do |format|
          format.html { render plain: "权限不足，请联系管理员。", status: :forbidden }
          format.json { render json: { error: { message: "Unauthenticated" } }, status: :forbidden }
        end
      end

      def handle_remote_ip_not_allowed
        respond_to do |format|
          format.html { render plain: "请确认访问客户端已加入IP白名单", status: :forbidden }
          format.json { render json: { error: { message: "Not in ip whitelist" } }, status: :forbidden }
        end
      end
  end
end
