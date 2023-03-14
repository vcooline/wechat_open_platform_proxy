module WechatOpenPlatformProxy
  class WebsiteUserAuthorizeService < WebsiteAppBaseService
    def get_base_info(code)
      query_params = {
        appid: website_app.app_id,
        secret: website_app.app_secret,
        code:,
        grant_type: "authorization_code"
      }
      resp = Faraday.get "https://api.weixin.qq.com/sns/oauth2/access_token?#{query_params.to_query}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "#{self.class.name} get_base_info resp: #{resp_body.squish}"

      JSON.parse(resp_body)
    end

    def get_user_info(code)
      base_info = get_base_info(code)
      user_info = base_info_to_user_info(base_info)
      base_info.merge(user_info)
    end
    alias_method :get_authorized_info, :get_user_info

    # def refresh_auth_info(refresh_token = nil)
    # end

    private

      def base_info_to_user_info(base_info)
        query_params = {
          access_token: base_info["access_token"],
          openid: base_info["openid"],
          lang: "zh_CN"
        }
        resp = Faraday.get "https://api.weixin.qq.com/sns/userinfo?#{query_params.to_query}"
        resp_body = safe_response_body(resp)
        Rails.logger.info "#{self.class.name} base_info_to_user_info resp: #{resp_body.squish}"

        JSON.parse(resp_body)
      end
  end
end
