# WechatOpenPlatformProxy
微信开放平台代理Engine

## Usage

* 第三方平台

  Mount engine in host rails routes: mount WechatOpenPlatformProxy::Engine, at: "/owx"

  登录开放平台https://open.weixin.qq.com，进入管理中心-第三方平台

  创建信息：

    登录授权的发起页域名: example.com

    授权事件接收URL: http://example.com/owx/third_party_platforms/:third_party_platform_uid/authorization_events

    消息校验Token: 同third_party_platform的messages_checking_token设置

    消息加解密Key: 同third_party_platform的message_encryption_key设置

    消息与事件接收URL: http://example.com/owx/third_party_platforms/:third_party_platform_uid/official_accounts/$APPID$/messages


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'wechat_open_platform_proxy', git: "git@github.com:vcooline/wechat_open_platform_proxy.git", branch: "master"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install wechat_open_platform_proxy
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
