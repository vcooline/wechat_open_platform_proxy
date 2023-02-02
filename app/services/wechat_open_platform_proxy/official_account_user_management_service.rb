module WechatOpenPlatformProxy
  class OfficialAccountUserManagementService < OfficialAccountBaseService
    def user_list(next_openid = nil)
      Rails.logger.info "OfficialAccountUserManagementService user list reqt: #{next_openid}"
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/user/get?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}&next_openid=#{next_openid}"
      Rails.logger.info "OfficialAccountUserManagementService user list resp: #{resp.body.squish}"

      resp
    end

    def user_info(open_id)
      query_params = {
        access_token: OfficialAccountCacheStore.new(official_account).fetch_access_token,
        openid: open_id,
        lang: "zh_CN"
      }
      Rails.logger.info "OfficialAccountUserManagementService user info reqt: #{open_id}"
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/user/info?#{query_params.to_query}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountUserManagementService user info resp: #{resp_body.squish}"
      JSON.parse(resp_body)
    end
  end
end
