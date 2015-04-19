class AddIndexes < ActiveRecord::Migration
  def change
    drop_table :active_admin_comments
    add_index :batters, :pitcher_id
    add_index :batters, :team_id
    add_index :pitchers, :team_id
    add_index :matchups, :visitor_id
    add_index :matchups, :home_id

  end
end
