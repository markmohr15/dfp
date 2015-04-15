class AddFdSalaryToPlayers < ActiveRecord::Migration
  def change
    add_column :batters, :fd_salary, :integer
    add_column :pitchers, :fd_salary, :integer
  end
end
