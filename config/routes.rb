Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    resources :athletes, only: [:index, :create, :show]
    resources :championships, only: [:index, :create, :show, :update] do
      resources :championship_performances, only: [:index, :create], as: 'performances'
    end
  end
end
