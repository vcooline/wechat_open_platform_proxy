WechatOpenPlatformProxy::Engine.routes.draw do
  get "welcome/index"
  root "welcome#index"

  resources :third_party_platforms, param: :uid, only: [:index, :show], shallow: true do
    scope module: :third_party_platforms do
      resources :authorization_events, only: [:create]
    end

    resources :official_accounts, param: :app_id, only: [:new, :show], shallow: true  do
      collection do
        get :authorize_callback
      end

      scope module: :official_accounts do
        resources :messages, only: [:create]

        defaults format: :json do
          get "jssdk/wx_config"
          get "jssdk/card_wx_config"
        end
      end
    end

    resources :wechat_users, only: [:new, :show] do
      collection do
        get :authorize_callback
      end
    end
  end
end
