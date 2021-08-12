module WechatOpenPlatformProxy
  class OfficialAccountBaseService
    attr_reader :official_account

    def initialize(official_account)
      @official_account = official_account
    end

    private
      def safe_response_body(resp)
        return "{}" if resp.body.blank?
        resp.body.force_encoding("UTF-8").encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      end
  end
end
