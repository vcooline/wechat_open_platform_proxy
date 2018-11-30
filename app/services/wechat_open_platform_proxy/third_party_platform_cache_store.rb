module WechatOpenPlatformProxy
  class ThirdPartyPlatformCacheStore
    attr_reader :third_party_platform

    def initialize(platform)
      @third_party_platform = platform
    end

    def write_component_verify_ticket(content)
      Rails.cache.write(verify_ticket_cache_key, content) if content.present?
    end

    def fetch_pre_auth_code(force_renew = false)
      delete_pre_auth_code if force_renew
      read_pre_auth_code || create_pre_auth_code
    end

    def delete_pre_auth_code
      Rails.cache.delete(pre_auth_code_cache_key)
    end

    def fetch_access_token(force_renew = false)
      delete_access_token if force_renew
      read_access_token || renew_access_token
    end

    private
      def read_component_verify_ticket
        Rails.cache.read(verify_ticket_cache_key)
      end

      def read_pre_auth_code
        Rails.cache.read(pre_auth_code_cache_key)
      end

      def create_pre_auth_code
        request_params = { component_appid: third_party_platform.app_id }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{fetch_access_token}", request_params.to_json
        Rails.logger.info "ThirdPartyPlatformCacheStore create_pre_auth_code(#{third_party_platform.app_id}) resp: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        if resp_info['errcode'].to_i.zero? && resp_info["pre_auth_code"].present? && resp_info["expires_in"].present?
          Rails.cache.write(pre_auth_code_cache_key, resp_info["pre_auth_code"], expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes))
        end
      end

      def read_access_token
        Rails.cache.read(access_token_cache_key)
      end

      def delete_access_token
        Rails.cache.delete(access_token_cache_key)
      end

      def renew_access_token
        request_params = {
          component_appid: third_party_platform.app_id,
          component_appsecret: third_party_platform.app_secret,
          component_verify_ticket: read_component_verify_ticket
        }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_component_token", request_params.to_json
        Rails.logger.info "ThirdPartyPlatformCacheStore renew_access_token(#{third_party_platform.app_id}) resp: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        if resp_info['errcode'].to_i.zero? && resp_info["component_access_token"].present? && resp_info["expires_in"].present?
          Rails.cache.fetch(access_token_cache_key, expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["component_access_token"] }
        end
      end

      def verify_ticket_cache_key
        "component_verify_ticket_#{third_party_platform.app_id}"
      end

      def pre_auth_code_cache_key
        "pre_auth_code_#{third_party_platform.app_id}"
      end

      def access_token_cache_key
        "component_access_token_#{third_party_platform.app_id}"
      end
  end
end
