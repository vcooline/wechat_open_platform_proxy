module WechatOpenPlatformProxy
  class OfficialAccountQrCodeService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def create_qrcode(qr_code_params)
      Rails.logger.info "OfficialAccountQrCodeService create_qrcode reqt: #{qr_code_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", qr_code_params.to_json
      Rails.logger.info "OfficialAccountQrCodeService create_qrcode resp: #{resp.body}"

      resp
    end
  end
end
