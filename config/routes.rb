Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1 routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      scope :auth do
        post :login, to: 'auth#login'
        post :register, to: 'auth#register'
        post 'forgot-password', to: 'auth#forgot_password'
        post 'validate-reset-token', to: 'auth#validate_reset_token'
        post 'reset-password', to: 'auth#reset_password'
        get :me, to: 'auth#me'
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
