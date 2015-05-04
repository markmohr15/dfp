class AddSelectedToBatterAndPitcher < ActiveRecord::Migration
  def change
    add_column :batters, :selected, :boolean
    add_column :pitchers, :selected, :boolean
  end
end
