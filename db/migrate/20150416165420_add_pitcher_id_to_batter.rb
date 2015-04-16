class AddPitcherIdToBatter < ActiveRecord::Migration
  def change
    add_column :batters, :pitcher_id, :integer
  end
end
