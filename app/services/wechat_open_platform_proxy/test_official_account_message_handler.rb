module WechatOpenPlatformProxy
  class TestOfficialAccountMessageHandler
    attr_reader :official_account

    def initialize(account)
      @official_account = account.is_a?(WechatOpenPlatformProxy::OfficialAccount) ? account : OfficialAccount.find_by(app_id: account)
    end

    def handle_official_account_message(message_params)
      if message_params["xml"]["MsgType"] == "event" # 公众号检测步骤1: 公众号的事件
        handle_event_message(message_params)
      elsif message_params["xml"]["Content"] == "TESTCOMPONENT_MSG_TYPE_TEXT" # 公众号检测步骤2: 公众号的文本消息
        handle_text_message(message_params)
      elsif message_params["xml"]["MsgType"] == "text" && message_params["xml"]["Content"] =~ /QUERY_AUTH_CODE/ # 公众号检测步骤3: 客服消息
        handle_customer_service_message(message_params) # 客服消息
      else
        nil # 响应空字符串
      end
    end

    def handle_mini_program_message(message_params)
      if message_params["xml"]["MsgType"] == "text" && message_params["xml"]["Content"] =~ /QUERY_AUTH_CODE/ # 小程序检测步骤1: 客服消息
        handle_customer_service_message(message_params) # 客服消息
      end
    end

    private
      def handle_event_message(message_params)
        <<~END_TEXT_AREA
          <xml>
            <ToUserName><![CDATA[#{message_params['xml']['FromUserName']}]]></ToUserName>
            <FromUserName><![CDATA[#{message_params['xml']['ToUserName']}]]></FromUserName>
            <CreateTime>#{Time.now.to_i}</CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content><![CDATA[#{message_params['xml']['Event']}from_callback]]></Content>
          </xml>
        END_TEXT_AREA
      end

      def handle_text_message(message_params)
        <<~END_TEXT_AREA
          <xml>
            <ToUserName><![CDATA[#{message_params['xml']['FromUserName']}]]></ToUserName>
            <FromUserName><![CDATA[#{message_params['xml']['ToUserName']}]]></FromUserName>
            <CreateTime>#{Time.now.to_i}</CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content><![CDATA[TESTCOMPONENT_MSG_TYPE_TEXT_callback]]></Content>
          </xml>
        END_TEXT_AREA
      end

      def handle_customer_service_message(message_params)
        auth_code = message_params["xml"]["Content"].split(":").last
        # 使用授权码换取公众号的授权信息
        authorizer = OfficialAccountAuthorizeService.new(official_account.third_party_platform).get_account_info(auth_code)
        # 调用发送客服消息api
        resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{OfficialAccountCacheStore.new(authorizer).fetch_access_token}", { touser: message_params["xml"]["FromUserName"], msgtype: "text", text: {content: "#{auth_code}_from_api"} }.to_json
        Rails.logger.info "TestOfficialAccountMessageHandler handle_customer_service_message resp: #{resp.body}"

        nil
      end
  end
end
