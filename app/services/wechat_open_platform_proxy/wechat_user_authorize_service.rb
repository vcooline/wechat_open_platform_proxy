module WechatOpenPlatformProxy
  class WechatUserAuthorizeService
    attr_reader :official_account

    def initialize(account)
      @official_account = account
    end

    def get_base_info(code)
      query_params = {
        appid: official_account.app_id,
        code: code,
        grant_type: "authorization_code",
        component_appid: official_account.third_party_platform.app_id,
        component_access_token: ThirdPartyPlatformCacheStore.new(official_account.third_party_platform).fetch_access_token
      }
      resp = Faraday.get "https://api.weixin.qq.com/sns/oauth2/component/access_token?#{query_params.to_query}"
      Rails.logger.info "WechatUserAuthorizeService get_base_info resp: #{resp.body.squish}"
      JSON.parse(resp.body)
    end

    def get_user_info(code)
      base_info = get_base_info(code)
      user_info = base_info_to_user_info(base_info)
      base_info.merge(user_info)
    end

    def refresh_auth_info(refresh_token = nil)
      return unless refresh_token.present?

      query_params = { appid: official_account.app_id, grant_type: "refresh_token", refresh_token: refresh_token }
      resp = Faraday.get "https://api.weixin.qq.com/sns/oauth2/refresh_token?#{query_params.to_query}"
      Rails.logger.info "WechatUserAuthorizeService refresh_auth_info resp: #{resp.body.squish}"

      base_info = JSON.parse(resp.body)
      user_info = base_info["scope"].eql?("snsapi_userinfo") ? base_info_to_user_info(base_info) : {}
      base_info.merge(user_info)
    end

    def refresh_user_info(open_id)
      OfficialAccountUserManagementService.new(official_account).user_info(open_id)
    end

    def get_paid_union_id(open_id:, transaction_id: "", mch_id: "", out_trade_no: "")
      request_params = if transaction_id.present?
                        {openid: open_id, transaction_id: transaction_id}
                      else
                        {openid: open_id, mch_id: mch_id, out_trade_no: out_trade_no}
                      end
      Rails.logger.info "WechatOpenPlatformProxy::WechatUserAuthorizeService get_paid_union_id reqt: #{request_params.to_json}"
      resp = Faraday.get "https://api.weixin.qq.com/wxa/getpaidunionid?access_token=#{official_account.access_token}", request_params
      Rails.logger.info "WechatOpenPlatformProxy::WechatUserAuthorizeService get_paid_union_id resp: #{resp.body.squish}"

      JSON.parse(resp.body)#.dig("unionid")
    end

    private

      def base_info_to_user_info(base_info)
        query_params = {
          openid: base_info["openid"],
          lang: "zh_CN",
          access_token: base_info["access_token"]
        }
        resp = Faraday.get "https://api.weixin.qq.com/sns/userinfo?#{query_params.to_query}"
        Rails.logger.info "WechatUserAuthorizeService base_info_to_user_info resp: #{resp.body.squish}"

        JSON.parse(resp.body)
      end
  end
end
