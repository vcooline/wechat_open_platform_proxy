WechatOpenPlatformProxy::Engine.routes.draw do
  get "welcome/index"
  root "welcome#index"

  resources :third_party_platforms, param: :uid, only: [:show], shallow: true do
    resources :official_accounts, param: :app_id, only: [:new, :show], shallow: true  do
      collection do
        get :authorize_callback
      end

      scope module: :official_accounts do
        resources :authorization_events, only: [:create]
        resources :messages, only: [:create]
      end
    end

    resources :wechat_users, only: [:new, :show] do
      collection do
        get :authorize_callback
      end
    end
  end
end
