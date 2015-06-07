class AddZipsSplitsAndCurrentStatsToBatter < ActiveRecord::Migration
  def change
    add_column :batters, :zips_pa_rhp, :integer
    add_column :batters, :zips_ab_rhp, :integer
    add_column :batters, :zips_hits_rhp, :integer
    add_column :batters, :zips_doubles_rhp, :integer
    add_column :batters, :zips_triples_rhp, :integer
    add_column :batters, :zips_homers_rhp, :integer
    add_column :batters, :zips_rbis_rhp, :integer
    add_column :batters, :zips_walks_rhp, :integer
    add_column :batters, :zips_hbps_rhp, :integer
    add_column :batters, :zips_pa_lhp, :integer
    add_column :batters, :zips_ab_lhp, :integer
    add_column :batters, :zips_hits_lhp, :integer
    add_column :batters, :zips_doubles_lhp, :integer
    add_column :batters, :zips_triples_lhp, :integer
    add_column :batters, :zips_homers_lhp, :integer
    add_column :batters, :zips_rbis_lhp, :integer
    add_column :batters, :zips_walks_lhp, :integer
    add_column :batters, :zips_hbps_lhp, :integer

    add_column :batters, :pa_rhp, :integer
    add_column :batters, :ab_rhp, :integer
    add_column :batters, :hits_rhp, :integer
    add_column :batters, :doubles_rhp, :integer
    add_column :batters, :triples_rhp, :integer
    add_column :batters, :homers_rhp, :integer
    add_column :batters, :rbis_rhp, :integer
    add_column :batters, :walks_rhp, :integer
    add_column :batters, :hbps_rhp, :integer
    add_column :batters, :pa_lhp, :integer
    add_column :batters, :ab_lhp, :integer
    add_column :batters, :hits_lhp, :integer
    add_column :batters, :doubles_lhp, :integer
    add_column :batters, :triples_lhp, :integer
    add_column :batters, :homers_lhp, :integer
    add_column :batters, :rbis_lhp, :integer
    add_column :batters, :walks_lhp, :integer
    add_column :batters, :hbps_lhp, :integer

    add_column :batters, :pa, :integer
    add_column :batters, :ab, :integer
    add_column :batters, :hits, :integer
    add_column :batters, :doubles, :integer
    add_column :batters, :triples, :integer
    add_column :batters, :homers, :integer
    add_column :batters, :runs, :integer
    add_column :batters, :rbis, :integer
    add_column :batters, :walks, :integer
    add_column :batters, :hbps, :integer
    add_column :batters, :sb, :integer
    add_column :batters, :cs, :integer
  end
end
