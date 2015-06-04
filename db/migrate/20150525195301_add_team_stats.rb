class AddTeamStats < ActiveRecord::Migration
  def change
    add_column :teams, :base_runs, :float
    add_column :teams, :runs_per_nine, :float
    add_column :teams, :games, :integer
  end
end
