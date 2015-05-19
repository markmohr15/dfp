class AddSieraToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :sierra, :float
  end
end
