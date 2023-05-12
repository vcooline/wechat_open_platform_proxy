# 微信开放平台代理Engine

## 参数说明

  * third_party_platform_uid: 微信开放平台第三方应用唯一标识号

  * official_account_app_id: 公众号/小程序的appid

  * open_id: 微信用户对于公众号/小程序的身份标识

  * 公众号: 泛指公众号和小程序

### 公众号 绑定授权
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_account_authorization/new


* **Method**
    `URL Redirect`

* **URL params**

    **Required params**
    None

    **Optional params**
    `redirect_url=[string]`

* **Success Response**

    **Code**
    301

    **Content**

    `[redirect_url]?wechat_open_auth_code=xxx`

*  **Sample**

      Redirect `http://owx.example.com/third_party_platforms/:third_party_platform_uid/official_account_authorizations/new?redirect_url=[callback_redirect_url]`

      Callback `callback_redirect_url?wechat_open_auth_code=[code]`

### 公众号绑定授权后获取授权方信息
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_account_authorization/account_info

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    **Required params**
    `
    {
      auth_code: [string]
    }
    `

    **Optional params**
    None

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      {
        "app_id": "APPID",
        "refresh_token": "FILLER",
        "original_id": "FILLER",
        "nick_name": "FILLER",
        "head_img": "FILLER",
        "qrcode_url": "FILLER",
        "principal_name": "FILLER",
        "service_type_info": "FILLER",
        "verify_type_info": "FILLER",
        "business_info": "FILLER",
        "alias": "FILLER",
        "signature": "FILLER",
        "mini_program_info": "FILLER",
        "func_info": "FILLER"
      }
      ```

### 公众号信息查询
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    **Required params**
    None

    **Optional params**
    `
    {
      force_refresh: [string]
    }`

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      {
        "app_id": "APPID",
        "original_id": "FILLER",
        "nick_name": "FILLER",
        ...
      }
      ```

### 生成带参数的二维码
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/qr_codes

* **Method**
    `POST`

* **URL params**

    None

* **Data params**

    **Required params**
    `
    {qr_code: {"expire_seconds": 604800, "action_name": "QR_SCENE", "action_info": {"scene": {"scene_id": 123}}},
    }
    `

    参见官方模板消息体格式: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1443433542

    **Optional params**
    None

### 查询已申请模板消息的模板列表
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/private_templates

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    None

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      [
        {
          "template_id": "iPk5sOIt5X_flOVKn5GrTFpncEYTojx6ddbt8WYoV5s",
          "title": "领取奖金提醒",
          "primary_industry": "IT科技",
          "deputy_industry": "互联网|电子商务",
          "content": "{ {result.DATA} }\n\n领奖金额:{ {withdrawMoney.DATA} }\n领奖  时间:    { {withdrawTime.DATA} }\n银行信息:{ {cardInfo.DATA} }\n到账时间:  { {arrivedTime.DATA} }}",
          "example": "您已提交领奖申请\n\n领奖金额：xxxx元\n领奖时间：2013-10-10 12:22:22\n银行信息：xx银行(尾号xxxx)\n到账时间：预计xxxxxxx\n\n预计将于xxxx到达您的银行卡"
        },
        ...
      ]
      ```

### 查询已申请模板消息的模板详情
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/private_templates/:template_id

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    None

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      {
        "template_id": "iPk5sOIt5X_flOVKn5GrTFpncEYTojx6ddbt8WYoV5s",
        "title": "领取奖金提醒",
        "primary_industry": "IT科技",
        "deputy_industry": "互联网|电子商务",
        "content": "{ {result.DATA} }\n\n领奖金额:{ {withdrawMoney.DATA} }\n领奖  时间:    { {withdrawTime.DATA} }\n银行信息:{ {cardInfo.DATA} }\n到账时间:  { {arrivedTime.DATA} }}",
        "example": "您已提交领奖申请\n\n领奖金额：xxxx元\n领奖时间：2013-10-10 12:22:22\n银行信息：xx银行(尾号xxxx)\n到账时间：预计xxxxxxx\n\n预计将于xxxx到达您的银行卡"
      }
      ```

### 发送公众号模板消息
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/templated_messages

* **Method**
    `POST`

* **URL params**

    None

* **Data params**

    **Required params**
    `
    {
      templated_message: {
        "touser":"OPENID",
        "template_id":"ngqIpbwh8bUfcSsECmogfXcV14J0tQlEpBO27izEYtY",
        "url":"http://weixin.qq.com/download",  
        "miniprogram":{
          "appid":"xiaochengxuappid12345",
          "pagepath":"index?foo=bar"
        },
        "data":{
           "first": {
               "value":"恭喜你购买成功！",
               "color":"#173177"
           },
           "keyword1":{
               "value":"巧克力",
               "color":"#173177"
           },
           "keyword2": {
               "value":"39.8元",
               "color":"#173177"
           },
           "keyword3": {
               "value":"2014年9月22日",
               "color":"#173177"
           },
           "remark":{
               "value":"欢迎再次购买！",
               "color":"#173177"
           }
        }
      },
    }
    `

    参见官方模板消息体格式: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1433751277

    **Optional params**
    None

### Wechat user oauth
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/wechat_user_authorization/new

* **Method**
    `URL Redirect`

* **URL params**

    **Required params**
    None

    **Optional params**
    `redirect_url=[string]&scope=[snsapi_base|snsapi_userinfo]`

* **Success Response**

    **Code**
    301

    **Content**

    `[redirect_url]?wechat_oauth_code=xxx`

*  **Sample**

      Redirect `http://owx.example.com/third_party_platforms/:third_party_platform_uid/official_account_authorizations/:official_account_app_id/wechat_user_authorization/new?redirect_url=[callback_redirect_url]`

      Callback `[callback_redirect_url]?wechat_oauth_code=[code]`

### Wechat user oauth authorizer info (by POST)
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/wechat_user_authorization

* **Method**
    `POST`

* **URL params**

    None

* **Data params**

    **Required params**

    `
    {
      wechat_user_authorization: {
        code: [string]
      }
    }
    `

    **Optional params**

    `
    {
      wechat_user_authorization: {
        scope: [string]
      }
    }
    `

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      {
        "access_token": "FILLER",
        "expires_in": 7200,
        "refresh_token": "FILLER",
        "openid": "FILLER",
        "scope": "snsapi_base"
      }
      ```

      or

      ```json
      {
        "access_token": "FILLER",
        "expires_in": 7200,
        "refresh_token": "FILLER",
        "openid": "FILLER",
        "scope": "snsapi_userinfo",
        "unionid": "FILLER",
        "nickname": "FILLER",
        "sex": 1,
        "language": "en",
        "city": "松江",
        "province": "上海",
        "country": "中国",
        "headimgurl": "FILLER",
        "privilege": []
      }
      ```

### Wechat user oauth authorizer info (by GET)
------
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/wechat_user_authorization/[base_info|user_info]

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    **Required params**
    `
    {
      wechat_oauth_code: [string]
    }
    `

    **Optional params**
    None

* **Success Response**

    * **Code**
      200

      **Content**

      同上

### Wechat user info
* **URL**
    /third_party_platforms/:third_party_platform_uid/official_accounts/:official_account_app_id/wechat_users/:open_id

* **Method**
    `GET`

* **URL params**

    None

* **Data params**

    None

* **Success Response**

    * **Code**
      200

      **Content**

      ```json
      {
        "openid": "FILLER",
        ...
      }
      ```
