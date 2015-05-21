class UserLinesController < ApplicationController
  before_action :user_required

  def create
    @user_lines = params[:user_line].map { |attrs| UserLine.create(attrs.to_hash.merge(user_id: current_user.id)) unless attrs["visitor_off"] == "" && attrs["visitor_def"] == "" && attrs["home_off"] == "" && attrs["home_def"] == "" }
    redirect_to lines_path
  end

end
