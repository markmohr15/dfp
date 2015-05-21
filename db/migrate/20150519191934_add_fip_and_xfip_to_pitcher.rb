class AddFipAndXfipToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :fip, :float
    add_column :pitchers, :xfip, :float
  end
end
