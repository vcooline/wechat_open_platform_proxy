module WechatOpenPlatformProxy
  class OfficialAccountTemplatedMessageService < OfficialAccountBaseService
    def send_message(message_params)
      Rails.logger.info "OfficialAccountTemplatedMessageService send_message reqt: #{message_params.to_json}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", message_params.to_json
      Rails.logger.info "OfficialAccountTemplatedMessageService send_message resp: #{resp.body.squish}"

      resp.tap { |r| GlobalApiErrorService.new(official_account).perform(r) if JSON.parse(r.body)&.dig("errcode").to_i.positive? }
    end

    def template_list
      resp = Faraday.get "https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}"
      resp_body = safe_response_body(resp)
      Rails.logger.info "OfficialAccountTemplatedMessageService template_list resp: #{resp_body.squish}"

      resp.tap { |r| GlobalApiErrorService.new(official_account).perform(r) if JSON.parse(r.body)&.dig("errcode").to_i.positive? }
    end

    def apply_template(short_id)
      Rails.logger.info "OfficialAccountTemplatedMessageService apply_template reqt: #{short_id}"
      resp = Faraday.post "https://api.weixin.qq.com/cgi-bin/template/api_add_template?access_token=#{OfficialAccountCacheStore.new(official_account).fetch_access_token}", { template_id_short: short_id }.to_json
      Rails.logger.info "OfficialAccountTemplatedMessageService apply_template resp: #{resp.body.squish}"

      resp
    end
  end
end
