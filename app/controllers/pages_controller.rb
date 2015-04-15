class PagesController < ApplicationController

  def home
    @batters = Batter.sorted_by_fd_pts_per_1000_dollars
    @pitchers = Pitcher.sorted_by_fd_pts_per_1000_dollars
  end

end
