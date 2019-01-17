module WechatOpenPlatformProxy
  class OfficialAccountShortUrlService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def perform(url_params)
      Rails.logger.info "OfficialAccountShortUrlService perform reqt:\n#{url_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/shorturl?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", url_params.to_json
      Rails.logger.info "OfficialAccountShortUrlService perform resp: #{resp.body}"

      resp
    end
  end
end
