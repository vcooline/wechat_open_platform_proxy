module WechatOpenPlatformProxy
  class OfficialAccountMemberCardService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def create_card(card_params)
      Rails.logger.info "OfficialAccountMemberCardService create_card reqt: #{JSON.dump(card_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/card/create?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", JSON.dump(card_params)
      Rails.logger.info "OfficialAccountMemberCardService create_card resp: #{resp.body.squish}"

      resp
    end

    def update_card(card_params)
      Rails.logger.info "OfficialAccountMemberCardService update_card reqt: #{JSON.dump(card_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/card/update?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", JSON.dump(card_params)
      Rails.logger.info "OfficialAccountMemberCardService update_card resp: #{resp.body.squish}"

      resp
    end

    def create_qrcode(card_id)
      qrcode_params = { action_name: "QR_CARD", action_info: { card: { card_id: } } }
      Rails.logger.info "OfficialAccountMemberCardService create_qrcode reqt: #{qrcode_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/card/qrcode/create?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", qrcode_params.to_json
      Rails.logger.info "OfficialAccountMemberCardService create_qrcode resp: #{resp.body.squish}"

      resp
    end

    def upload_image(original_url)
      tempfile = Tempfile.new([Digest::MD5.hexdigest(original_url), ".jpg"]).tap { |f| f.binmode and f.write(URI.open(Addressable::URI.parse(original_url).normalize).read) and f.rewind }
      payload = { buffer: Faraday::UploadIO.new(tempfile.path, "image") }

      Rails.logger.info "OfficialAccountMemberCardService upload_image reqt: #{original_url}"
      resp = api_client.post "/cgi-bin/media/uploadimg?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", payload
      Rails.logger.info "OfficialAccountMemberCardService upload_image resp: #{resp.body.squish}"

      tempfile.unlink
      resp
    end

    private

      def api_client
        Faraday.new("https://api.weixin.qq.com") do |conn|
          conn.request :multipart
          conn.request :url_encoded
          conn.adapter :net_http
        end
      end
  end
end
