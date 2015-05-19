class AddSteamerToPitcher < ActiveRecord::Migration
  def change
    add_column :pitchers, :steamer_wins, :integer
    add_column :pitchers, :steamer_games, :integer
    add_column :pitchers, :steamer_gs, :integer
    add_column :pitchers, :steamer_ip, :integer
    add_column :pitchers, :steamer_er, :integer
    add_column :pitchers, :steamer_so, :integer
    add_column :pitchers, :steamer_whip, :integer
    add_column :pitchers, :steamer_homers, :integer
    add_column :pitchers, :steamer_hits, :integer
  end
end
