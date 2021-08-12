module WechatOpenPlatformProxy
  class OfficialAccountSubscriptionMessageService < OfficialAccountBaseService

    def category_list
      resp = Faraday.get "https://api.weixin.qq.com/wxaapi/newtmpl/getcategory?access_token=#{official_account.access_token}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountSubscriptionMessageService category_list resp: #{resp_body.squish}"

      JSON.parse(resp_body)["data"]
    end

    def template_list
      resp = Faraday.get "https://api.weixin.qq.com/wxaapi/newtmpl/gettemplate?access_token=#{official_account.access_token}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountSubscriptionMessageService template_list resp: #{resp_body.squish}"

      JSON.parse(resp_body)["data"]
    end

    def pub_template_list(query_params={})
      Rails.logger.info "OfficialAccountSubscriptionMessageService pub_template_list reqt: #{JSON.dump(query_params)}"
      resp = Faraday.get "https://api.weixin.qq.com/wxaapi/newtmpl/getpubtemplatetitles?#{query_params.merge(access_token: official_account.access_token).to_query}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountSubscriptionMessageService pub_template_list resp: #{resp_body.squish}"

      JSON.load(resp_body)
    end

    def pub_template_keywords(tid)
      query_params = {
        tid: tid,
        access_token: OfficialAccountCacheStore.new(official_account).fetch_access_token
      }
      Rails.logger.info "OfficialAccountSubscriptionMessageService pub_template_keywords reqt: #{tid}"
      resp = Faraday.get "https://api.weixin.qq.com/wxaapi/newtmpl/getpubtemplatekeywords?#{query_params.to_query}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountSubscriptionMessageService pub_template_keywords resp: #{resp_body.squish}"

      JSON.parse(resp_body)["data"]
    end

    def apply_template(apply_params={})
      Rails.logger.info "OfficialAccountSubscriptionMessageService apply_template reqt: #{JSON.dump(apply_params)}"
      resp = Faraday.post "https://api.weixin.qq.com/wxaapi/newtmpl/addtemplate?access_token=#{official_account.access_token}", JSON.dump(apply_params),  {"Content-Type": "application/json"}
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountSubscriptionMessageService apply_template resp: #{resp_body.squish}"

      JSON.load(resp_body)
    end

    def delete_template(pri_tmpl_id)
      Rails.logger.info "OfficialAccountSubscriptionMessageService delete_template reqt: #{pri_tmpl_id}"
      resp = Faraday.post "https://api.weixin.qq.com/wxaapi/newtmpl/deltemplate?access_token=#{official_account.access_token}", {priTmplId: pri_tmpl_id}.to_json, {"Content-Type": "application/json"}
      Rails.logger.info "OfficialAccountSubscriptionMessageService delete_template resp: #{resp.body.squish}"

      JSON.parse(resp.body)
    end

    def send_message(message_params)
      Rails.logger.info "OfficialAccountSubscriptionMessageService send_message reqt: #{message_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/subscribe/bizsend?access_token=#{official_account.access_token}", JSON.dump(message_params), {"Content-Type": "application/json"}
      Rails.logger.info "OfficialAccountSubscriptionMessageService send_message resp: #{resp.body.squish}"

      JSON.parse(resp.body)
    end

  end
end
