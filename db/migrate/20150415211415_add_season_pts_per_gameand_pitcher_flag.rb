class AddSeasonPtsPerGameandPitcherFlag < ActiveRecord::Migration
  def change
    add_column :batters, :fd_season_ppg, :float
    add_column :pitchers, :fd_season_ppg, :float
    add_column :pitchers, :starting, :boolean, default: false
  end
end
