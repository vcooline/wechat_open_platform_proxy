module WechatOpenPlatformProxy
  class OfficialAccountGuideService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def guide_list(params={})
      Rails.logger.info "OfficialAccountGuideService guide_list reqt: #{params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/guide/getguideacctlist?access_token=#{access_token}", params.to_json
      Rails.logger.info "OfficialAccountGuideService guide_list resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    def guide_qrcode(params={})
      Rails.logger.info "OfficialAccountGuideService guide_qrcode reqt: #{params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/guide/guidecreateqrcode?access_token=#{access_token}", params.to_json
      Rails.logger.info "OfficialAccountGuideService guide_qrcode resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    def bind_guide_customer(params)
      Rails.logger.info "OfficialAccountGuideService bind_guide_customer reqt: #{params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/guide/addguidebuyerrelation?access_token=#{access_token}", params.to_json
      Rails.logger.info "OfficialAccountGuideService bind_guide_customer resp: #{resp.body.squish}"

      resp
    end

    private
      def access_token
        OfficialAccountCacheStore.new(official_account).fetch_access_token
      end
  end
end
