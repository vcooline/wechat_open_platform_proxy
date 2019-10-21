module WechatOpenPlatformProxy
  class OfficialAccountMemberCardService
    attr_reader :wechat_member_card, :official_account

    def initialize(official_account, wechat_member_card)
      @wechat_member_card = wechat_member_card
      @official_account = official_account
    end

    def update
      resp = Faraday.post("https://api.weixin.qq.com/card/update?access_token=#{access_token}", JSON.dump(update_card_params))
      result = JSON.parse(resp.body)
      Rails.logger.info "update member_card"
      Rails.logger.info "#{result}"
      if result['errcode'].zero?
        [true]
      else
        [false, result['errmsg']]
      end
    end

    def create
      resp = Faraday.post("https://api.weixin.qq.com/card/create?access_token=#{access_token}", JSON.dump(create_card_params))
      result = JSON.parse(resp.body)
      Rails.logger.info "create member_card"
      Rails.logger.info "#{result}"
      if result['errcode'].zero?
        wechat_member_card.update!(card_id: result['card_id'])
        [true]
      else
        [false, result['errmsg']]
      end
    end

    def qr_code
      return nil unless wechat_member_card.card_id
      Rails.cache.fetch("#{wechat_member_card.card_id}_qrcode", expires_in: 360.days) do
        params = {
                   "action_name": "QR_CARD",
                   "action_info": {
                     "card": {
                       "card_id": wechat_member_card.card_id,
                     }
                   }
                 }
        rsp = Faraday.post("https://api.weixin.qq.com/card/qrcode/create?access_token=#{access_token}", params.to_json)
        result = JSON.parse(rsp.body)
        Rails.logger.info "member_card qr_code"
        Rails.logger.info "#{result}"
        result['url']
      end
    end

    private

    def update_card_params
     {
        "card_id": wechat_member_card.card_id,
        "member_card": {
            "background_pic_url": background_pic_url,
            "base_info": {
                "logo_url": logo_url,
                "title": wechat_member_card.title,
                "custom_url": wechat_member_card.custom_url,
                "custom_url_name": wechat_member_card.custom_url_name,
                "custom_url_sub_title": wechat_member_card.custom_url_sub_title,
                "promotion_url": wechat_member_card.promotion_url,
                "promotion_url_name": wechat_member_card.promotion_url_name,
                "promotion_url_sub_title": wechat_member_card.promotion_url_sub_title,
                "color": "Color100",
                "notice": wechat_member_card.notice,
            },
            "custom_cell1": wechat_member_card.custom_cell1,
            "custom_cell2": wechat_member_card.custom_cell2,
            "custom_field1": wechat_member_card.custom_field1,
            "custom_field2": wechat_member_card.custom_field2,
            "custom_field3": wechat_member_card.custom_field3,
            "prerogative": wechat_member_card.prerogative,
        }
      }
    end

    def create_card_params
      {
        "card": {
            "card_type": "MEMBER_CARD",
            "member_card": {
                "background_pic_url": background_pic_url,
                "base_info": {
                    "logo_url": logo_url,
                    "code_type": "CODE_TYPE_TEXT",
                    "brand_name": wechat_member_card.brand_name,
                    "title": wechat_member_card.title,
                    "custom_url": wechat_member_card.custom_url,
                    "custom_url_name": wechat_member_card.custom_url_name,
                    "custom_url_sub_title": wechat_member_card.custom_url_sub_title,
                    "promotion_url": wechat_member_card.promotion_url,
                    "promotion_url_name": wechat_member_card.promotion_url_name,
                    "promotion_url_sub_title": wechat_member_card.promotion_url_sub_title,
                    "sub_title": "",
                    "date_info": {
                        "type": "DATE_TYPE_PERMANENT"
                    },
                    "color": "Color100",
                    "notice": wechat_member_card.notice,
                    "description": "",
                    "location_id_list": [],
                    "get_limit": 1,
                    "can_share": true,
                    "can_give_friend": false,
                    "status": "CARD_STATUS_VERIFY_OK",
                    "sku": {
                        "quantity": 999999910,
                        "total_quantity": 1000000000
                    },
                    "use_all_locations": false,
                    "area_code_list": []
                },
                "supply_bonus": false,
                "supply_balance": false,
                "custom_cell1": wechat_member_card.custom_cell1,
                "custom_cell2": wechat_member_card.custom_cell2,
                "custom_field1": wechat_member_card.custom_field1,
                "custom_field2": wechat_member_card.custom_field2,
                "custom_field3": wechat_member_card.custom_field3,
                "prerogative": wechat_member_card.prerogative,
                "auto_activate": true,
                "advanced_info": {
                    "time_limit": [
                        {
                            "type": "MONDAY"
                        },
                        {
                            "type": "TUESDAY"
                        },
                        {
                            "type": "WEDNESDAY"
                        },
                        {
                            "type": "THURSDAY"
                        },
                        {
                            "type": "FRIDAY"
                        },
                        {
                            "type": "SATURDAY"
                        },
                        {
                            "type": "SUNDAY"
                        }
                    ],
                    "text_image_list": [],
                    "business_service": [],
                    "consume_share_card_list": [],
                    "use_condition": {
                        "can_use_with_other_discount": false,
                        "can_use_with_membercard": false
                    },
                    "share_friends": false
                }
            }
        }
      }
    end

    def background_pic_url
      input_file = open(wechat_member_card.background_pic_url)
      output_file = Tempfile.new(['output', '.jpg'])

      output_file.binmode
      output_file.write input_file.read
      output_file.flush

      output_file.seek(0)

      payload = { buffer: Faraday::UploadIO.new(output_file.path, 'image') }
      resp = api_client.post "/cgi-bin/media/uploadimg?access_token=#{access_token}", payload
      Rails.logger.info "**********#{resp.body}"
      output_file.unlink
      result = JSON.parse(resp.body)
      result['url']
    end

    def logo_url
      input_file = open(wechat_member_card.logo_url)
      output_file = Tempfile.new(['output', '.jpg'])

      output_file.binmode
      output_file.write input_file.read
      output_file.flush

      output_file.seek(0)

      payload = { buffer: Faraday::UploadIO.new(output_file.path, 'image') }
      resp = api_client.post "/cgi-bin/media/uploadimg?access_token=#{access_token}", payload
      Rails.logger.info "**********#{resp.body}"
      output_file.unlink
      result = JSON.parse(resp.body)
      result['url']
    end

    def api_client
      Faraday.new("https://api.weixin.qq.com") do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
      end
    end

    def access_token
      WechatOpenPlatformProxy::OfficialAccountCacheStore.new(official_account).fetch_access_token
    end
  end
end
