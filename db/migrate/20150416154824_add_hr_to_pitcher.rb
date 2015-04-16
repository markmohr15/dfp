class AddHrToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :homers, :integer
  end
end
