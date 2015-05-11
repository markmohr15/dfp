class AddBallparkFdPpgToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :ballpark_fd_ppg, :float
  end
end
