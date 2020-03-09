Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
get '/stock/:ticker',  to: 'stocks#getStock'
post '/login', to: 'auth#login'
get '/auth', to: 'auth#persist'
end
