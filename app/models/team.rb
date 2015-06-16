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
#  base_runs      :float
#  runs_per_nine  :float
#  games          :integer
#  alias          :string
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

  def zips_overnight_offense opp_pitcher
    pitcher = Pitcher.find_by name: opp_pitcher
    if pitcher.throws == "right"
      batters = Batter.where("team_id = ? and rh_overnight_lineup_spot > ?", self.id, 0)
    else
      batters = Batter.where("team_id = ? and lh_overnight_lineup_spot > ?", self.id, 0)
    end
    lineup = batters.to_a
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
      if pitcher.throws == "right"
        hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3
        sb_counter += batter.zips_sb / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot)
        cs_counter += batter.zips_cs / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot)
        singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3

        unless batter.zips_ab_rhp.nil?
          hits_counter += batter.zips_hits_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          walks_counter += batter.zips_walks_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          homers_counter += batter.zips_homers_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          doubles_counter += batter.zips_doubles_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          triples_counter += batter.zips_triples_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          abs_counter += batter.zips_ab_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          hbps_counter += batter.zips_hbps_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          singles_counter += batter.zips_singles_rhp / batter.zips_pa_rhp.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
        else
          hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
          singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.rh_overnight_lineup_spot) / 3 * 2
        end
      else
        hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3
        sb_counter += batter.zips_sb / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot)
        cs_counter += batter.zips_cs / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot)
        singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3

        unless batter.zips_ab_lhp.nil?
          hits_counter += batter.zips_hits_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          walks_counter += batter.zips_walks_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          homers_counter += batter.zips_homers_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          doubles_counter += batter.zips_doubles_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          triples_counter += batter.zips_triples_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          abs_counter += batter.zips_ab_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          hbps_counter += batter.zips_hbps_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          singles_counter += batter.zips_singles_lhp / batter.zips_pa_lhp.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
        else
          hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
          singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.overnight_nine_inning_papg(batter.lh_overnight_lineup_spot) / 3 * 2
        end
      end
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

  def zips_true_lineup_offense opp_pitcher
    batters = Batter.where("team_id = ? and lineup_spot > ?", self.id, 0)
    lineup = batters.to_a
    if batters.count < 9
      pitcher_hitting = Batter.find_by(name: "Pitcher Batting", team_id: self.id)
      if Batter.where(lineup_spot:8, team_id: self.id).exists?
        pitcher_hitting.lineup_spot = 9
      else
        pitcher_hitting.lineup_spot = 8
      end
      pitcher_hitting.save
      lineup << pitcher_hitting
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
    pitcher = Pitcher.find_by name: opp_pitcher
    lineup.each do |batter|
      if pitcher.throws == "right"
        hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.nine_inning_papg/ 3
        sb_counter += batter.zips_sb / batter.zips_pa.to_f * batter.nine_inning_papg
        cs_counter += batter.zips_cs / batter.zips_pa.to_f * batter.nine_inning_papg
        singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.nine_inning_papg / 3

        unless batter.zips_ab_rhp.nil?
          hits_counter += batter.zips_hits_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          walks_counter += batter.zips_walks_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          homers_counter += batter.zips_homers_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          doubles_counter += batter.zips_doubles_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          triples_counter += batter.zips_triples_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          abs_counter += batter.zips_ab_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          hbps_counter += batter.zips_hbps_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
          singles_counter += batter.zips_singles_rhp / batter.zips_pa_rhp.to_f * batter.nine_inning_papg / 3 * 2
        else
          hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
        end
      else
        hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.nine_inning_papg / 3
        sb_counter += batter.zips_sb / batter.zips_pa.to_f * batter.nine_inning_papg
        cs_counter += batter.zips_cs / batter.zips_pa.to_f * batter.nine_inning_papg
        singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.nine_inning_papg / 3

        unless batter.zips_ab_lhp.nil?
          hits_counter += batter.zips_hits_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          walks_counter += batter.zips_walks_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          homers_counter += batter.zips_homers_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          doubles_counter += batter.zips_doubles_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          triples_counter += batter.zips_triples_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          abs_counter += batter.zips_ab_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          hbps_counter += batter.zips_hbps_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
          singles_counter += batter.zips_singles_lhp / batter.zips_pa_lhp.to_f * batter.nine_inning_papg / 3 * 2
        else
          hits_counter += batter.zips_hits / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          walks_counter += batter.zips_walks / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          homers_counter += batter.zips_homers / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          doubles_counter += batter.zips_doubles / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          triples_counter += batter.zips_triples / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          abs_counter += batter.zips_ab / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          hbps_counter += batter.zips_hbps / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
          singles_counter += batter.zips_singles / batter.zips_pa.to_f * batter.nine_inning_papg / 3 * 2
        end
      end
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
    return if starter.zips_ip.blank?
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

  def steamer_defense sp
    starter = Pitcher.find_by(name: sp)
    return if starter.steamer_ip.blank?
    starter_innings = starter.steamer_ip / starter.steamer_games.to_f
    relievers = Pitcher.where(team_id: self.id, reliever: true)
    earned_runs = starter.steamer_er / starter.steamer_ip.to_f * starter_innings
    er_counter = 0
    ip_counter = 0
    relievers.each do |r|
      er_counter += r.steamer_er
      ip_counter += r.steamer_ip
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

  def set_base_runs ab, pa, hits, singles, doubles, triples, hr, bb, ibb, hbp, sb, cs, gdp
    tb = singles + doubles * 2 + triples * 3 + hr * 4
    a = hits + bb + hbp - hr - 0.5 * ibb
    b = (1.4 * tb - 0.6 * hits - 3 * hr + 0.1 * (bb + hbp - ibb) + 0.9 * (sb - cs - gdp)) * 1.1
    c = ab - hits + cs + gdp
    d = hr
    self.base_runs = ((a * b) / (b + c) + d).round(2)
  end

  def runs_per_nine_inn runs, ab, hits, cs, gdp
    self.runs_per_nine = (runs / (ab - hits + cs + gdp).to_f * 27).round(2)
  end

  def bsr_per_game
    (self.base_runs / self.games.to_f).round(2)
  end

  def self.get_games date   #format - 2015-05-20
    agent = Mechanize.new
    games = agent.get("http://www.baseballpress.com/lineups/" + date).search('.team-data')
    data = games.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    (data.length / 2).times do
      team = data.pop
      home_team = team[1][0].split(/\r?\n/).first
      team2 = data.pop
      away_team = team2[1][0].split(/\r?\n/).first
      Matchup.create(home_id: Team.find_by(name: home_team).id, visitor_id: Team.find_by(name: away_team).id, day: date)
    end
  end

  def self.get_stats
    agent = Mechanize.new
    stuff = agent.get("http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=0&season1=2015&ind=0&team=0,ts&rost=0&age=0&filter=&players=0").search(".rgRow") + agent.get("http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=0&season1=2015&ind=0&team=0,ts&rost=0&age=0&filter=&players=0").search(".rgAltRow")
    morestuff = agent.get("http://www.fangraphs.com/depthcharts.aspx?position=Standings").search(".depth_team")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    moredata = morestuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    data.each do |x|
      team = Team.find_by name: x[1][0]
      team.set_base_runs (x[3][0]).to_i, (x[4][0]).to_i, (x[5][0]).to_i, x[6][0].to_i, x[7][0].to_i, x[8][0].to_i, x[9][0].to_i, x[12][0].to_i, x[13][0].to_i, x[15][0].to_i, x[19][0].to_i, x[20][0].to_i, x[18][0].to_i
      team.runs_per_nine_inn x[10][0].to_i, x[3][0].to_i, x[5][0].to_i, x[20][0].to_i, x[18][0].to_i
      team.save
    end
    moredata.each do |x|
      team = Team.find_by name: x[0][0]
      team.games = x[1][0].to_i
      team.save
    end
  end

  def self.check_lineups
    teams = Team.all
    teams_array = []
    teams.each do |team|
      teams_array << team.name + Batter.where("lineup_spot > ? and team_id = ?", 0, team.id).count.to_s
    end
    teams_array
  end

end
