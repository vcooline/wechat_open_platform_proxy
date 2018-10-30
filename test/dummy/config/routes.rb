Rails.application.routes.draw do
  mount WechatOpenPlatformProxy::Engine => "/wechat_open_platform_proxy"
end
