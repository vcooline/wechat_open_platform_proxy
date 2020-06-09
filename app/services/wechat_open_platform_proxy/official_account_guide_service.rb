module WechatOpenPlatformProxy
  class OfficialAccountGuideService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def guide_list(params={})
      Rails.logger.info "OfficialAccountGuideService guide_list reqt"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/guide/getguideacctlist?access_token=#{access_token}", params.to_json
      Rails.logger.info "OfficialAccountGuideService guide_list resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    def guide_qrcode(params={})
      Rails.logger.info "OfficialAccountGuideService guide_qrcode reqt"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/guide/guidecreateqrcode?access_token=#{access_token}", params.to_json
      Rails.logger.info "OfficialAccountGuideService guide_qrcode resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    private
      def access_token
        OfficialAccountCacheStore.new(official_account).fetch_access_token
      end
  end
end
