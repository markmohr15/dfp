class AddLineupSpotToBatter < ActiveRecord::Migration
  def change
    add_column :batters, :lineup_spot, :integer
  end
end
