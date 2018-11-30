module WechatOpenPlatformProxy
  class OfficialAccountCacheStore
    attr_reader :official_account, :third_party_platform

    def initialize(account)
      @official_account = account
      @third_party_platform = account.third_party_platform
    end

    def fetch_access_token(force_renew=false)
      delete_access_token if force_renew
      read_access_token || renew_access_token
    end

    private
      def read_access_token
        Rails.cache.read(access_token_cache_key)
      end

      def delete_access_token
        Rails.cache.delete(access_token_cache_key)
      end

      def renew_access_token
        request_params = {
          component_appid: third_party_platform.app_id,
          authorizer_appid: official_account.app_id,
          authorizer_refresh_token: official_account.refresh_token
        }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_authorizer_token?component_access_token=#{ThirdPartyPlatformCacheStore.new(third_party_platform).fetch_access_token}", request_params.to_json
        Rails.logger.info "OfficialAccountCacheStore renew_access_token(#{third_party_platform.uid}/#{official_account.app_id}) resp: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        if resp_info["errcode"].to_i.zero? && resp_info["authorizer_refresh_token"].present? && resp_info["authorizer_access_token"].present? && resp_info["expires_in"].present?
          official_account.update(refresh_token: resp_info["authorizer_refresh_token"])
          Rails.cache.fetch(access_token_cache_key, expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["authorizer_access_token"] }
        end
      end

      def access_token_cache_key
        "access_token_#{third_party_platform.uid}_#{official_account.app_id}"
      end
  end
end
