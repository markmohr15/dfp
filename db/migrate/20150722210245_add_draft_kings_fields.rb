class AddDraftKingsFields < ActiveRecord::Migration
  def change
    add_column :batters, :dk_salary, :integer
    add_column :batters, :dk_season_ppg, :float
    add_column :batters, :zips_adj_dk_ppg, :float
    add_column :batters, :dk_alias, :string
    add_column :pitchers, :dk_salary, :integer
    add_column :pitchers, :dk_season_ppg, :float
    add_column :pitchers, :dk_alias, :string
    add_column :teams, :dk_park_factor, :float
  end
end
