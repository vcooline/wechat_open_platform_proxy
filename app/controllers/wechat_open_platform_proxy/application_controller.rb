module WechatOpenPlatformProxy
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    include AuthGuard
    include UrlUtility
  end
end
