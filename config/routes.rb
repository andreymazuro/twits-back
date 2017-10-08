Rails.application.routes.draw do
  resources :retweets
  resources :subscribes
  resources :posts
  resources :users

  delete '/subscribes', to: 'subscribes#unsubscribe'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
