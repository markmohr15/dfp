class ChangeSteamerWhipToFloat < ActiveRecord::Migration
  def change
    remove_column :pitchers, :steamer_whip
    add_column :pitchers, :steamer_whip, :float
  end
end
