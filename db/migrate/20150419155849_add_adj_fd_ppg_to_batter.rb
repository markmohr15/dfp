class AddAdjFdPpgToBatter < ActiveRecord::Migration
  def change
    add_column :batters, :adj_fd_ppg, :float
  end
end
