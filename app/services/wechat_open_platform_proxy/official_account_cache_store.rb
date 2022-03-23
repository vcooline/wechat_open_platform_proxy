module WechatOpenPlatformProxy
  class OfficialAccountCacheStore
    attr_reader :official_account, :third_party_platform

    def initialize(account)
      @official_account = account
      @third_party_platform = account.third_party_platform
    end

    def fetch_access_token(force_renew: false)
      delete_access_token if force_renew
      read_access_token || renew_access_token
    end

    def fetch_jsapi_ticket(force_renew: false)
      delete_jsapi_ticket if force_renew
      read_jsapi_ticket || renew_jsapi_ticket
    end

    def fetch_wx_card_ticket(force_renew: false)
      delete_wx_card_ticket if force_renew
      read_wx_card_ticket || renew_wx_card_ticket
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
        Rails.logger.info "OfficialAccountCacheStore renew_access_token(#{third_party_platform.uid}/#{official_account.app_id}) resp: #{resp.body.squish}"

        resp_info = JSON.parse(resp.body)
        if resp_info["errcode"].to_i.zero? && resp_info["authorizer_refresh_token"].present? && resp_info["authorizer_access_token"].present? && resp_info["expires_in"].present?
          official_account.update(refresh_token: resp_info["authorizer_refresh_token"])
          Rails.cache.fetch(access_token_cache_key, expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["authorizer_access_token"] }
        end
      end

      def read_jsapi_ticket
        Rails.cache.read(jsapi_ticket_cache_key)
      end

      def delete_jsapi_ticket
        Rails.cache.delete(jsapi_ticket_cache_key)
      end

      def renew_jsapi_ticket
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{fetch_access_token}&type=jsapi"
        Rails.logger.info "OfficialAccountCacheStore renew_jsapi_ticket(#{third_party_platform.uid}/#{official_account.app_id}) resp: #{resp.body.squish}"

        resp_info = JSON.parse(resp.body)
        if resp_info["errcode"].to_i.zero? && resp_info["ticket"].present? && resp_info["expires_in"].present?
          Rails.cache.fetch(jsapi_ticket_cache_key, expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["ticket"] }
        end
      end

      def read_wx_card_ticket
        Rails.cache.read(wx_card_ticket_cache_key)
      end

      def delete_wx_card_ticket
        Rails.cache.delete(wx_card_ticket_cache_key)
      end

      def renew_wx_card_ticket
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{fetch_access_token}&type=wx_card"
        Rails.logger.info "OfficialAccountCacheStore renew_wx_card_ticket(#{third_party_platform.uid}/#{official_account.app_id}) resp: #{resp.body.squish}"

        resp_info = JSON.parse(resp.body)
        if resp_info["errcode"].to_i.zero? && resp_info["ticket"].present? && resp_info["expires_in"].present?
          Rails.cache.fetch(wx_card_ticket_cache_key, expires_in: (resp_info["expires_in"].to_i.seconds - 5.minutes), race_condition_ttl: 5) { resp_info["ticket"] }
        end
      end

      def access_token_cache_key
        "access_token:#{third_party_platform.uid}:#{official_account.app_id}"
      end

      def jsapi_ticket_cache_key
        "jsapi_ticket:#{third_party_platform.uid}:#{official_account.app_id}"
      end

      def wx_card_ticket_cache_key
        "wx_card_ticket:#{third_party_platform.uid}:#{official_account.app_id}"
      end
  end
end
