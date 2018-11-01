module WechatOpenPlatformProxy
  class OfficialAccountCacheStore
    attr_reader :official_account

    def initialize(account)
      @official_account = account.is_a?(WechatOpenPlatformProxy::OfficialAccount) ? account : OfficialAccount.find_by(app_id: account)
    end

    def fetch_access_token(force_renew=false)
      delete_access_token if force_renew || read_access_token.blank?
      read_access_token || renew_access_token
    end

    private
      def read_access_token
        Rails.cache.read("official_account_#{official_account.app_id}_access_token")
      end

      def delete_access_token
        Rails.cache.delete("official_account_#{official_account.app_id}_access_token")
      end

      def renew_access_token
        request_params = {
          component_appid: official_account.third_party_platform.app_id,
          authorizer_appid: official_account.app_id,
          authorizer_refresh_token: official_account.refresh_token
        }
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/component/api_authorizer_token?component_access_token=#{ThirdPartyPlatformCacheStore.new(official_account.third_party_platform).fetch_access_token}", request_params.to_json
        Rails.logger.info "OfficialAccountCacheStore renew_access_token(#{official_account.app_id}) resp: #{resp.body}"

        resp_info = JSON.parse(resp.body)
        if resp_info["errcode"].to_i.zero? && resp_info["authorizer_refresh_token"].present? && resp_info["authorizer_access_token"].present?
          official_account.update(refresh_token: resp_info["authorizer_refresh_token"])
          Rails.cache.fetch("official_account_#{official_account.app_id}_access_token", expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["authorizer_access_token"] }
        end
      end
  end
end
