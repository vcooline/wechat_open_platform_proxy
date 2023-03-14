module WechatOpenPlatformProxy
  class WebsiteAppBaseService
    attr_reader :website_app

    def initialize(website_app)
      @website_app = website_app
    end

    private

      def safe_response_body(resp)
        return "{}" if resp.body.blank?

        resp.body.force_encoding("UTF-8").encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      end
  end
end
