module WechatOpenPlatformProxy
  class OfficialAccountUserManagementService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def user_list(next_openid=nil)
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
      Rails.logger.info "OfficialAccountUserManagementService user info resp: #{resp.body.squish}"
      JSON.parse(resp.body)
    end
  end
end
