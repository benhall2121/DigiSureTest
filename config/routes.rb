Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :bank_accounts
  resources :account_transactions

  get "/pages/:page" => "pages#show"

  root 'pages#home'
end
