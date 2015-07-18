Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  put "/", to: "pages#update", as: :update_players
  get "/fanduel", to: "pages#fanduel"
  post "user_lines", to: "user_lines#create", as: :user_lines
  get "/teams", to: "pages#teams", as: :teams
  root to: "pages#lines"
end
