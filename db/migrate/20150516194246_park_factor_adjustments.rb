class ParkFactorAdjustments < ActiveRecord::Migration
  def change
    rename_column :teams, :park_factor, :fd_park_factor
    add_column :teams, :park_factor, :float
  end
end
