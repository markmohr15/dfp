class ChangeTeamToIntegerForPlayers < ActiveRecord::Migration
  def change
    remove_column :batters, :team
    remove_column :pitchers, :team
    add_column :batters, :team_id, :integer
    add_column :pitchers, :team_id, :integer
  end
end
