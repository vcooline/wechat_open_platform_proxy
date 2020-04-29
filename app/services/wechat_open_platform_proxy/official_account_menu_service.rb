module WechatOpenPlatformProxy
  class OfficialAccountMenuService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    def current
      Rails.logger.info "OfficialAccountMenuService current reqt: #{official_account.app_id}"
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/get_current_selfmenu_info?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}"
      Rails.logger.info "OfficialAccountMenuService current resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    def create(menu_params)
      raise "Not implemented"
    end

    def delete
      Rails.logger.info "OfficialAccountMenuService delete reqt: #{official_account.app_id}"
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}"
      Rails.logger.info "OfficialAccountMenuService delete resp: #{resp.body.squish}"

      JSON.load(resp.body)
    end

    def add_conditional
      raise "Not implemented"
    end
  end
end
