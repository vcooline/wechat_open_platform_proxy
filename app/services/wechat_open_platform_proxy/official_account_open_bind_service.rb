module WechatOpenPlatformProxy
  class OfficialAccountOpenBindService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def create
      Rails.logger.info "OfficialAccountOpenBindService create reqt: #{official_account.app_id}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/open/create?access_token=#{official_account.access_token}", { appid: official_account.app_id }.to_json
      Rails.logger.info "OfficialAccountOpenBindService create resp: #{resp.body.squish}"

      JSON.parse(resp.body)["open_appid"].presence&.then do |open_app_id|
        official_account.third_party_platform.open_accounts.create(app_id: open_app_id, principal_name: official_account.principal_name).tap { |open_account| save_binding(open_account) }
      end
    end

    def bind(open_app_id = nil)
      open_app_id ||= get&.app_id

      Rails.logger.info "OfficialAccountOpenBindService bind reqt: #{official_account.app_id}, #{open_app_id}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/qrcode/bind?access_token=#{official_account.access_token}", { appid: official_account.app_id, open_appid: open_app_id }.to_json
      Rails.logger.info "OfficialAccountOpenBindService bind resp: #{resp.body.squish}"

      if JSON.parse(resp.body)["errcode"].zero?
        official_account.third_party_platform.open_accounts.find_or_create_by(app_id: open_app_id, principal_name: official_account.principal_name).tap { |open_account| save_binding(open_account) }
      else
        false
      end
    end

    def unbind(open_app_id)
      Rails.logger.info "OfficialAccountOpenBindService get reqt: #{official_account.app_id}, #{open_app_id}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/open/unbind?access_token=#{official_account.access_token}", { appid: official_account.app_id, open_appid: open_app_id }.to_json
      Rails.logger.info "OfficialAccountOpenBindService get resp: #{resp.body.squish}"

      if JSON.parse(resp.body)["errcode"].zero?
        official_account.third_party_platform.open_accounts.find_or_initialize_by(app_id: open_app_id, principal_name: official_account.principal_name).tap { |_open_account| save_binding(nil) }
      else
        false
      end
    end

    def get
      Rails.logger.info "OfficialAccountOpenBindService get reqt: #{official_account.app_id}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/open/get?access_token=#{official_account.access_token}", { appid: official_account.app_id }.to_json
      Rails.logger.info "OfficialAccountOpenBindService get resp: #{resp.body.squish}"

      JSON.parse(resp.body)["open_appid"].presence&.then do |open_app_id|
        official_account.third_party_platform.open_accounts.find_or_create_by(app_id: open_app_id, principal_name: official_account.principal_name).tap { |open_account| save_binding(open_account) }
      end
    end

    private

      def save_binding(open_account)
        official_account.update(open_account: open_account)
      end
  end
end
