class AddAliasToTeamsBattersAndPitchers < ActiveRecord::Migration
  def change
    add_column :batters, :alias, :string
    add_column :pitchers, :alias, :string
    add_column :teams, :alias, :string
  end
end
