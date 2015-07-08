class RenameBaseRunstoBaseRunsPerNine < ActiveRecord::Migration
  def change
    rename_column :teams, :base_runs, :base_runs_per_nine
  end
end
