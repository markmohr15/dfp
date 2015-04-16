class AddHitsToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :hits, :integer
  end
end
