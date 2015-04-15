Rails.application.routes.draw do
  devise_for :users

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  end

  root to: "pages#home"
end
