module WechatOpenPlatformProxy
  class OfficialAccountAssetManagementService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def upload_temporary_asset(asset_params)
      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset reqt:\n#{asset_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/media/upload?access_token=?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", asset_params.to_json
      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset resp: #{resp.body}"

      JSON.load(resp.body)
    end
  end
end
