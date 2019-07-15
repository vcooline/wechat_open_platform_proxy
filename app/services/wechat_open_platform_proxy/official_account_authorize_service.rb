module WechatOpenPlatformProxy
  class OfficialAccountAuthorizeService
    AuthorizationInfoApiError = Class.new StandardError
    AuthorizerInfoError = Class.new StandardError

    attr_reader :third_party_platform

    def initialize(third_party_platform)
      @third_party_platform = third_party_platform
    end

    def get_account_info(auth_code)
      authorization_info = get_authorization_info(auth_code)
      authorizer_info = get_authorizer_info(authorization_info["authorizer_appid"])["authorizer_info"]
      set_official_account(authorization_info, authorizer_info)
    end

    def refresh_account_info(app_id)
      authorization_info, authorizer_info = get_authorizer_info(app_id).values_at("authorization_info", "authorizer_info")
      set_official_account(authorization_info, authorizer_info)
    end

    private
      def get_authorization_info(auth_code)
        request_params = { component_appid: third_party_platform.app_id, authorization_code: auth_code }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token=#{ThirdPartyPlatformCacheStore.new(third_party_platform).fetch_access_token}", request_params.to_json
        Rails.logger.info "OfficialAccountAuthorizeService get_authorization_info resp: #{resp.body.squish}"

        resp_info = JSON.parse(resp.body)
        raise AuthorizationInfoApiError, resp.body unless resp_info["errcode"].to_i.zero?

        resp_info["authorization_info"].tap do |authorization_info|
          Rails.cache.write("official_account_#{authorization_info['authorizer_appid']}_access_token", authorization_info["authorizer_access_token"], expires_in: (authorization_info["expires_in"].to_i.seconds - 5.minutes))
        end
      end

      def get_authorizer_info(official_account_app_id)
        request_params = { component_appid: third_party_platform.app_id, authorizer_appid: official_account_app_id }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token=#{ThirdPartyPlatformCacheStore.new(third_party_platform).fetch_access_token}", request_params.to_json
        Rails.logger.info "OfficialAccountAuthorizeService get_authorizer_info(#{third_party_platform.uid}/#{official_account_app_id}): #{resp.body.squish}"

        resp_info = JSON.parse(resp.body)
        raise AuthorizerInfoError, resp.body unless resp_info["errcode"].to_i.zero?
        resp_info
      end

      def set_official_account(authorization_info, authorizer_info)
        third_party_platform.official_accounts.find_or_initialize_by(app_id: authorization_info["authorizer_appid"]).tap do |official_account|
          official_account.update(
            refresh_token: (authorization_info["authorizer_refresh_token"].presence || official_account.refresh_token),
            original_id: authorizer_info["user_name"],
            nick_name: authorizer_info["nick_name"],
            head_img: authorizer_info["head_img"],
            qrcode_url: authorizer_info["qrcode_url"],
            principal_name: authorizer_info["principal_name"],
            service_type_info: authorizer_info["service_type_info"],
            verify_type_info: authorizer_info["verify_type_info"],
            business_info: authorizer_info["business_info"],
            alias: authorizer_info["alias"],
            signature: authorizer_info["signature"],
            mini_program_info: authorizer_info["MiniProgramInfo"],
            func_info: authorization_info["func_info"]
          )
        end
      end
  end
end
