ActiveAdmin.setup do |config|

  config.site_title = "Dfp"
  config.site_title_link = "/admin"
  config.authentication_method = :authenticate_active_admin_user!
  config.default_namespace = :admin
  config.logout_link_method = :get
  config.current_user_method = :current_user
  config.root_to = "dashboard#index"
  config.register_javascript "admin.js"
  config.logout_link_path = :destroy_user_session_path
  config.comments = false
  config.show_comments_in_menu = false
  config.batch_actions = true
  config.default_per_page = 50

  config.namespace :admin do |ns|
    ns.build_menu :utility_navigation do |menu|
      menu.add label: "View Site &rarr;".html_safe, url: "/"
      ns.add_logout_button_to_menu menu
    end
  end

  def authenticate_active_admin_user!
    unless current_user.try(:admin?) || false
      redirect_to root_url
    end
  end
end


