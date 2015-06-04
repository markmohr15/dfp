class AddEraToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :era, :float
  end
end
