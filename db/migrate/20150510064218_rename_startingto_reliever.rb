class RenameStartingtoReliever < ActiveRecord::Migration
  def change
    rename_column :pitchers, :starting, :reliever
  end
end
