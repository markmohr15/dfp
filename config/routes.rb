Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  put "/", to: "pages#update", as: :update_players

  root to: "pages#home"
end
