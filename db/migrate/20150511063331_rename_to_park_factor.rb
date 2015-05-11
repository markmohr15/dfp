class RenameToParkFactor < ActiveRecord::Migration
  def change
    rename_column :teams, :ballpark_fd_ppg, :park_factor
  end
end
