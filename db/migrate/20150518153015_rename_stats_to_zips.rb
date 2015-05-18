class RenameStatsToZips < ActiveRecord::Migration
  def change
    rename_column :pitchers, :wins, :zips_wins
    rename_column :pitchers, :games, :zips_ganmes
    rename_column :pitchers, :gs, :zips_gs
    rename_column :pitchers, :ip, :zips_ip
    rename_column :pitchers, :er, :zips_er
    rename_column :pitchers, :so, :zips_so
    rename_column :pitchers, :whip, :zips_whip
    rename_column :pitchers, :homers, :zips_homers
    rename_column :pitchers, :hits, :zips_hits
    rename_column :batters, :pa, :zips_pa
    rename_column :batters, :ab, :zips_ab
    rename_column :batters, :hits, :zips_hits
    rename_column :batters, :doubles, :zips_doubles
    rename_column :batters, :triples, :zips_triples
    rename_column :batters, :homers, :zips_homers
    rename_column :batters, :runs, :zips_runs
    rename_column :batters, :rbis, :zips_rbis
    rename_column :batters, :walks, :zips_walks
    rename_column :batters, :hbps, :zips_hbps
    rename_column :batters, :sb, :zips_sb
    rename_column :batters, :cs, :zips_cs
    rename_column :batters, :adj_fd_ppg, :zips_adj_fd_ppg

  end
end
