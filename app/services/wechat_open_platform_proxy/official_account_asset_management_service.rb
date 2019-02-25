module WechatOpenPlatformProxy
  class OfficialAccountAssetManagementService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def upload_temporary_asset(type: , file_path: , mime_type: )
      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset reqt:\n#{type}|#{file_path}|#{mime_type}"
      con = Faraday.new("https://api.weixin.qq.com/cgi-bin/media/upload?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}") do |conn|
        conn.request :multipart
        conn.adapter :net_http
      end
      payload[:type] = type
      payload[:media] = Faraday::UploadIO.new(file_path, mime_type)

      resp = con.post '/', payload
      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset resp: #{resp.body}"

      JSON.load(resp.body)
    end
  end
end
