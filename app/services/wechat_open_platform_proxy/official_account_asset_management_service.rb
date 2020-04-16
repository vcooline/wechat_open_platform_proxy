module WechatOpenPlatformProxy
  class OfficialAccountAssetManagementService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    # 图片（image）: 2M，支持PNG\JPEG\JPG\GIF格式
    # 语音（voice）：2M，播放长度不超过60s，支持AMR\MP3格式
    # 视频（video）：10MB，支持MP4格式
    # 缩略图（thumb）：64KB，支持JPG格式
    def upload_temporary_asset(asset_params)
      file_path = asset_params[:file].is_a?(String) ? asset_params[:file] : asset_params[:file].path
      mime_type = asset_params[:mime_type].presence || MIME::Types.of(file_path).detect{|mt| mt.media_type.in?(%w(image voice video thumb))}.to_s
      type = asset_params[:type].presence || MIME::Type.new(mime_type).media_type

      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset reqt: #{file_path}|#{type}|#{mime_type}"
      payload = { type: type, media: Faraday::UploadIO.new(file_path, mime_type) }
      resp = api_client.post "/cgi-bin/media/upload?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", payload
      Rails.logger.info "OfficialAccountAssetManagementService upload_temporary_asset resp: #{resp.body.squish}"

      resp
    end

    def download_temporary_asset(media_id)
      query_params = {
        access_token: OfficialAccountCacheStore.new(official_account).fetch_access_token,
        media_id: media_id
      }
      Rails.logger.info "OfficialAccountAssetManagementService download_temporary_asset reqt: #{media_id}"
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/media/get?#{query_params.to_query}"
      Rails.logger.info "OfficialAccountAssetManagementService download_temporary_asset resp #{resp.status}: #{resp.headers.values_at('content-type', 'content-disposition').join('; ')}"

      resp.body
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
