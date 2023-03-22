Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index\
  root to: 'link_account#index'
  get '/link_accounts/', to: 'link_account#index'
  post '/link_accounts/', to: 'link_account#create'
end
