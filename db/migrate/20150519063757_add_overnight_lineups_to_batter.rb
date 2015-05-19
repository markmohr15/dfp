class AddOvernightLineupsToBatter < ActiveRecord::Migration
  def change
    add_column :batters, :rh_overnight_lineup_spot, :integer
    add_column :batters, :lh_overnight_lineup_spot, :integer
    add_column :pitchers, :throws, :integer
  end
end
