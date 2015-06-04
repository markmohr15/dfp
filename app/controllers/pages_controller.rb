class PagesController < ApplicationController

  def home
    @catchers = Batter.catchers_sorted_by_adj_fd_pts_per_1000_dollars
    @firstbasemen = Batter.firstbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @secondbasemen = Batter.secondbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @thirdbasemen = Batter.thirdbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    @shortstops = Batter.shortstops_sorted_by_adj_fd_pts_per_1000_dollars
    @outfielders = Batter.outfielders_sorted_by_adj_fd_pts_per_1000_dollars
    @pitchers = Pitcher.sorted_by_zips_fd_pts_per_1000_dollars
  end

  def update
    Pitcher.update_all selected:false
    Batter.update_all selected:false
    @pitchers = Pitcher.find(params[:pitcher_ids])
    @batters = Batter.find(params[:batter_ids])
    @pitchers.each do |p|
      p.selected = true
      p.save
    end
    @batters.each do |b|
      b.selected = true
      b.save
    end
    lineup = Batter.optimal_fd
    flash[:alert] = lineup
    redirect_to root_path
  end

  def lines
    @matchups = Matchup.where.not(visiting_pitcher_id: nil).where.not(home_pitcher_id: nil).where(day: Date.today..Date.today + 2.days, ).order("day").order("created_at desc")
  end

end
