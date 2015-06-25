class AddMultipleAliases < ActiveRecord::Migration
  def change
    rename_column :batters, :alias, :fd_alias
    rename_column :pitchers, :alias, :fd_alias
    add_column :batters, :fg_alias, :string
    add_column :pitchers, :fg_alias, :string
  end
end
