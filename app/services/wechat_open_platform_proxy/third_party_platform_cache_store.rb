module WechatOpenPlatformProxy
  class ThirdPartyPlatformCacheStore
    attr_reader :third_party_platform

    def initialize(third_party_platform)
      @third_party_platform = third_party_platform
    end

    def write_component_verify_ticket(content)
      Rails.cache.write("component_verify_ticket_#{third_party_platform.app_id}", content) if content.present?
    end

    def fetch_pre_auth_code(force_renew = false)
      delete_pre_auth_code if force_renew || read_pre_auth_code.blank?
      read_pre_auth_code || create_pre_auth_code
    end

    def delete_pre_auth_code
      Rails.cache.delete("pre_auth_code_#{third_party_platform.app_id}")
    end

    def fetch_access_token(force_renew = false)
      delete_access_token if force_renew || read_access_token.blank?
      read_access_token || renew_access_token
    end

    private
      def read_pre_auth_code
        Rails.cache.read("pre_auth_code_#{third_party_platform.app_id}")
      end

      def create_pre_auth_code
        request_params = { component_appid: third_party_platform.app_id }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{fetch_access_token}", request_params.to_json
        Rails.logger.info "ThirdPartyPlatformCacheStore create_pre_auth_code response: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        Rails.cache.fetch("pre_auth_code_#{third_party_platform.app_id}", expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["pre_auth_code"] } if resp_info['errcode'].to_i.zero?
      end

      def read_access_token
        Rails.cache.read("component_access_token_#{third_party_platform.app_id}")
      end

      def delete_access_token
        Rails.cache.delete("component_access_token_#{third_party_platform.app_id}")
      end

      def renew_access_token
        request_params = {
          component_appid: third_party_platform.app_id,
          component_appsecret: third_party_platform.app_secret,
          component_verify_ticket: Rails.cache.read("component_verify_ticket_#{third_party_platform.app_id}")
        }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_component_token", request_params.to_json
        Rails.logger.info "ThirdPartyPlatformCacheStore renew_access_token response: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        Rails.cache.fetch("component_access_token_#{third_party_platform.app_id}", expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["component_access_token"] } if resp_info['errcode'].to_i.zero?
      end
  end
end
