Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :transactions
  resources :users
get '/stock/:ticker',  to: 'stocks#getStock'
get '/portfolio/:id',  to: 'stocks#portfolio'
post '/login', to: 'auth#login'
get '/auth', to: 'auth#persist'
end
