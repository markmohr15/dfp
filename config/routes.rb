Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  put "/", to: "pages#update", as: :update_players
  get "/lines", to: "pages#lines"
  root to: "pages#home"
end
