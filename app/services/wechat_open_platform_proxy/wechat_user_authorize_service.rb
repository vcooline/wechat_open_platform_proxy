module WechatOpenPlatformProxy
  class WechatUserAuthorizeService
    attr_reader :official_account

    def initialize(account)
      @official_account = account
    end

    def get_base_info(code)
      request_params = {
        appid: official_account.app_id,
        code: code,
        grant_type: 'authorization_code',
        component_appid: official_account.third_party_platform.app_id,
        component_access_token: ThirdPartyPlatformCacheStore.new(official_account.third_party_platform).fetch_access_token
      }
      resp = Faraday.get "https://api.weixin.qq.com/sns/oauth2/component/access_token?#{request_params.to_query}"
      Rails.logger.info "WechatUserAuthorizeService get_base_info resp: #{resp.body.squish}"
      JSON.parse(resp.body)
    end

    def get_user_info(code)
      base_info = get_base_info(code)
      request_params = {
        openid: base_info["openid"],
        lang: "zh_CN",
        access_token: base_info["access_token"]
      }
      resp = Faraday.get "https://api.weixin.qq.com/sns/userinfo?#{request_params.to_query}"
      Rails.logger.info "WechatUserAuthorizeService get_user_info resp: #{resp.body.squish}"
      JSON.parse(resp.body).reverse_merge(base_info)
    end

    def refresh_user_info(open_id)
      OfficialAccountUserManagementService.new(official_account).user_info(open_id)
    end
  end
end
