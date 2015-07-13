class AddIndices < ActiveRecord::Migration
  def change
    add_index :matchups, :visiting_pitcher_id
    add_index :matchups, :home_pitcher_id
    add_index :user_lines, :matchup_id
    add_index :user_lines, :user_id
    add_index :wagers, :user_id
    add_index :wagers, :matchup_id
    add_index :wagers, :team_id
  end
end
