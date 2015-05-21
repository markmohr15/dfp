# == Schema Information
#
# Table name: teams
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  fd_park_factor :float
#  park_factor    :float
#

class Team < ActiveRecord::Base

  has_many :matchups_as_visitor, class_name: "Matchup", foreign_key: "visitor_id"
  has_many :matchups_as_home, class_name: "Matchup", foreign_key: "home_id"
  has_many :batters
  has_many :pitchers

  accepts_nested_attributes_for :batters
  accepts_nested_attributes_for :pitchers

  def fd_ppg
    lineup = Batter.where("team_id = ? and lineup_spot > ?", self.id, 0)
    pts_counter = 0
    lineup.each do |batter|
      pts_counter += batter.fd_pts_per_game
    end
    pts_counter
  end

  def home?
    game = Matchup.find_by("visitor_id in (?) or home_id in (?)", self.id, self.id)
    return if game.nil?
    if game.visitor_id == self.id
      false
    else
      true
    end
  end

  def zips_true_lineup_offense
    batters = Batter.where("team_id = ? and lineup_spot > ?", self.id, 0)
    lineup = batters.to_a
    if batters.count < 9
      pitcher = Batter.find_by(name: "Pitcher Batting", team_id: self.id)
      if Batter.where(lineup_spot:8, team_id: self.id).exists?
        pitcher.lineup_spot = 9
      else
        pitcher.lineup_spot = 8
      end
      pitcher.save
      lineup << pitcher
    end
    hits_counter = 0
    walks_counter = 0
    homers_counter = 0
    singles_counter = 0
    doubles_counter = 0
    triples_counter = 0
    abs_counter = 0
    hbps_counter = 0
    sb_counter = 0
    cs_counter = 0
    pa_counter = 0
    lineup.each do |batter|
      hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.nine_inning_papg
      walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.nine_inning_papg
      homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.nine_inning_papg
      doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.nine_inning_papg
      triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.nine_inning_papg
      abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.nine_inning_papg
      hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.nine_inning_papg
      sb_counter += batter.zips_sb / batter.zips_pa.to_f * batter.nine_inning_papg
      cs_counter += batter.zips_cs / batter.zips_pa.to_f * batter.nine_inning_papg
      singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.nine_inning_papg
    end
    tb = singles_counter + doubles_counter * 2 + triples_counter * 3 + homers_counter * 4
    a = hits_counter + walks_counter + hbps_counter - homers_counter - 0.1
    b = (1.4 * tb - 0.6 * hits_counter - 3 * homers_counter + 0.1 * (walks_counter + hbps_counter - 0.2) + 0.9 * (sb_counter - cs_counter - 0.75)) * 1.1
    c = 27
    d = homers_counter
    runs = (a * b) / (b + c) + d
    if self.park_factor > 1
      runs = runs / ((self.park_factor - 1) / 2 + 1)
    else
      runs = runs / (1 - (1 - self.park_factor) / 2)
    end
    runs.round(2)
  end

  def zips_defense sp
    starter = Pitcher.find_by(name: sp)
    starter_innings = starter.zips_ip / starter.zips_games.to_f
    relievers = Pitcher.where(team_id: self.id, reliever: true)
    earned_runs = starter.zips_er / starter.zips_ip.to_f * starter_innings
    er_counter = 0
    ip_counter = 0
    relievers.each do |r|
      er_counter += r.zips_er
      ip_counter += r.zips_ip
    end
    earned_runs += er_counter / ip_counter.to_f * (9 - starter_innings)
    if self.park_factor > 1
      earned_runs = earned_runs / ((self.park_factor - 1) / 2 + 1)
    else
      earned_runs = earned_runs / (1 - (1 - self.park_factor) / 2)
    end
    earned_runs += 0.3 #unearned runs
    earned_runs.round(2)
  end

  def self.base_runs ab, pa, hits, singles, doubles, triples, hr, bb, ibb, hbp, sb, cs, gdp
    tb = singles + doubles * 2 + triples * 3 + hr * 4
    a = hits + bb + hbp - hr - 0.5 * ibb
    b = (1.4 * tb - 0.6 * hits - 3 * hr + 0.1 * (bb + hbp - ibb) + 0.9 * (sb - cs - gdp)) * 1.1
    c = ab - hits + cs + gdp
    d = hr
    (a * b) / (b + c) + d
  end

end
