class PagesController < ApplicationController

  def home
    @catchers = Batter.catchers_sorted_by_adj_fd_pts_per_1000_dollars
    @firstbasemen = Batter.firstbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @secondbasemen = Batter.secondbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @thirdbasemen = Batter.thirdbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @shortstops = Batter.shortstops_sorted_by_adj_fd_pts_per_1000_dollars
    @outfielders = Batter.outfielders_sorted_by_adj_fd_pts_per_1000_dollars
    @pitchers = Pitcher.sorted_by_fd_pts_per_1000_dollars
  end

end
