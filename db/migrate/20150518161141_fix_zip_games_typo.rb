class FixZipGamesTypo < ActiveRecord::Migration
  def change
    rename_column :pitchers, :zips_ganmes, :zips_games
  end
end
