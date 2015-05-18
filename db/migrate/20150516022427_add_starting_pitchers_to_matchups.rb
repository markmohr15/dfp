class AddStartingPitchersToMatchups < ActiveRecord::Migration
  def change
    add_column :matchups, :visiting_pitcher_id, :integer
    add_column :matchups, :home_pitcher_id, :integer
  end
end
