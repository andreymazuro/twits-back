Rails.application.routes.draw do
  resources :retweets
  resources :subscribes
  resources :posts
  resources :users

  delete '/subscribes', to: 'subscribes#unsubscribe'
  get '/user/:username', to: 'posts#generate_user_wall'
  post '/get_user', to: 'users#get_user'
  post '/feed', to: 'posts#generate_feed'
  post '/sign_in', to: 'users#sign_in'
  get '/activate_account', to: 'users#activate_account'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
