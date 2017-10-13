Rails.application.routes.draw do
  devise_for :users
  # Devise said would be a good idea.
  root to: "home#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, :only => [:create, :index]
      resources :conversations, :only => [:create, :index] do
        resources :messages, :only => [:index, :create]
      end
      resources :sessions, :only => [:create, :destroy]
    end 
  end
end
