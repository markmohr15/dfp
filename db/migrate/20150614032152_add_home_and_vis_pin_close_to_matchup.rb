class AddHomeAndVisPinCloseToMatchup < ActiveRecord::Migration
  def change
    add_column :matchups, :pin_vis_close, :integer
    add_column :matchups, :pin_home_close, :integer
  end
end
