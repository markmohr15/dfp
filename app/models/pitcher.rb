# == Schema Information
#
# Table name: pitchers
#
#  id             :integer          not null, primary key
#  name           :string
#  zips_wins      :integer
#  zips_games     :integer
#  zips_gs        :integer
#  zips_ip        :integer
#  zips_er        :integer
#  zips_so        :integer
#  zips_whip      :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  fd_salary      :integer
#  fd_season_ppg  :float
#  reliever       :boolean          default("false")
#  zips_homers    :integer
#  zips_hits      :integer
#  team_id        :integer
#  selected       :boolean
#  sierra         :float
#  steamer_wins   :integer
#  steamer_games  :integer
#  steamer_gs     :integer
#  steamer_ip     :integer
#  steamer_er     :integer
#  steamer_so     :integer
#  steamer_homers :integer
#  steamer_hits   :integer
#  throws         :integer
#  fip            :float
#  xfip           :float
#  steamer_whip   :float
#  era            :float
#  fd_alias       :string
#  fg_alias       :string
#  dk_salary      :integer
#  dk_season_ppg  :float
#  dk_alias       :string
#
# Indexes
#
#  index_pitchers_on_team_id  (team_id)
#

class Pitcher < ActiveRecord::Base

  has_many :batters
  belongs_to :team
  has_many :matchups_as_visiting_pitcher, class_name: "Matchup", foreign_key: "visiting_pitcher_id"
  has_many :matchups_as_home_pitcher, class_name: "Matchup", foreign_key: "home_pitcher_id"

  enum throws: [ :right, :left ]

  def park_factor
    game = Matchup.find_by("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id)
    if game.nil?
      1
    elsif game.home_id == self.team_id
      self.team.park_factor
    else
      game.visitor.park_factor
    end
  end

  def self.get_stats pages
    agent = Mechanize.new
    stuff = []
    for i in 1..pages
      stuff += agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=20&type=c,4,5,11,7,8,13,9,122,45,62,6&season=2015&month=0&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgRow") + agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=20&type=c,4,5,11,7,8,13,9,122,45,62,6&season=2015&month=0&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgAltRow")
    end
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    not_found = []
    data.each do |x|
      pitcher = Pitcher.find_by(name: x[1][0])
      if pitcher.nil?
        pitcher = Pitcher.find_by(fg_alias: x[1][0])
      end
      if pitcher.nil?
        not_found << x[1][0] + " " + x[10][0] + " " + x[11][0] + " " + x[12][0] + " " + x[13][0]
      else
        pitcher.update_attributes(sierra: x[10][0].to_f, fip: x[11][0].to_f, xfip: x[12][0].to_f, era: x[13][0].to_f)
      end
    end
    not_found
  end

  def self.get_projections  #mass import
    agent = Mechanize.new
    stuff = []
    morestuff = []
    for i in 1..30
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgRow")
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgAltRow")
      morestuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=steamerr&team=' + i.to_s + '&lg=all&players=0').search(".rgRow")
      morestuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=steamerr&team=' + i.to_s + '&lg=all&players=0').search(".rgAltRow")
    end
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    moredata = morestuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    data.each do |x|
      pitcher = Pitcher.where(name: x[0].join(","), team_id: Team.find_by(name: x[1].join(",")).id).first_or_create
      pitcher.update_attributes(zips_wins: x[2].join(","), zips_games: x[6].join(","), zips_gs: x[5].join(","), zips_ip: x[7].join(","), zips_hits: x[8].join(","), zips_er: x[9].join(","), zips_homers: x[10].join(","), zips_so: x[11].join(","), zips_whip: x[13].join(",") )
    end
    moredata.each do |x|
      pitcher = Pitcher.where(name: x[0].join(","), team_id: Team.find_by(name: x[1].join(",")).id).first_or_create
      pitcher.update_attributes(steamer_wins: x[2].join(","), steamer_games: x[6].join(","), steamer_gs: x[5].join(","), steamer_ip: x[8].join(","), steamer_hits: x[9].join(","), steamer_er: x[10].join(","), steamer_homers: x[11].join(","), steamer_so: x[12].join(","), steamer_whip: x[14].join(",") )
    end
  end

  def self.get_zips_one_pitcher_data url, pitcher, team #indiv with zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projectionsin_show")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    pitcher = Pitcher.where(name: pitcher, team_id: Team.find_by(name: team).id).first_or_create
    pitcher.update_attributes(zips_wins: data[3][2][0], zips_games: data[3][5][0], zips_gs: data[3][6][0], zips_ip: data[3][12][0], zips_hits: data[3][14][0], zips_er: data[3][16][0], zips_homers: data[3][17][0], zips_so: data[3][23][0], zips_whip: data[3][10][0] )
  end

  def self.get_zips_one_pitcher_hidden url, pitcher, team, row #indiv import with no zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projections_hide")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    pitcher = Pitcher.where(name: pitcher, team_id: Team.find_by(name: team).id).first_or_create
    pitcher.update_attributes(zips_wins: data[row][2][0], zips_games: data[row][5][0], zips_gs: data[row][6][0], zips_ip: data[row][12][0], zips_hits: data[row][14][0], zips_er: data[row][16][0], zips_homers: data[row][17][0], zips_so: data[row][23][0], zips_whip: data[row][10][0] )
  end

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def display_dk_salary
    if self.dk_salary.blank?
      "N/A"
    else
      self.dk_salary
    end
  end

  def zips_fd_pts_per_game
    season_pts = self.zips_wins * 4 + self.zips_er * -1 + self.zips_so * 1 + self.zips_ip * 1
    season_pts / self.zips_games.to_f
  end

  def zips_dk_pts_per_game
    season_pts = self.zips_wins * 4 + self.zips_er * -2 + self.zips_so * 2 + self.zips_ip * 2.25 + self.zips_whip * self.zips_ip * -0.6
    season_pts / self.zips_games.to_f
  end

  def ytd_fd_pts_per_1000_dollars
    (self.fd_season_ppg / self.fd_salary * 1000).round(2)
  end

  def ytd_dk_pts_per_1000_dollars
    (self.dk_season_ppg / self.dk_salary * 1000).round(2)
  end

  def zips_fd_pts_per_1000_dollars
    if self.fd_salary.blank?
      "N/A"
    else
      sprintf('%.2f', self.zips_fd_pts_per_game / self.fd_salary * 1000)
    end
  end

  def zips_dk_pts_per_1000_dollars
    if self.dk_salary.blank?
      "N/A"
    else
      sprintf('%.2f', self.zips_dk_pts_per_game / self.dk_salary * 1000)
    end
  end

  def self.sorted_by_zips_fd_pts_per_1000_dollars
    Pitcher.where("fd_salary > 0").sort_by(&:zips_fd_pts_per_1000_dollars).reverse!
  end

  def self.sorted_by_zips_dk_pts_per_1000_dollars
    Pitcher.where("dk_salary > 0").sort_by(&:zips_dk_pts_per_1000_dollars).reverse!
  end

  def zips_non_homers
    self.zips_hits - self.zips_homers
  end

  def zips_singles
    self.zips_non_homers * 0.75
  end

  def zips_doubles
    self.zips_non_homers * 0.225
  end

  def zips_triples
    self.zips_non_homers * 0.025
  end

  def zips_bb_hbp
    self.zips_whip - self.zips_hits / self.zips_ip.to_f
  end

  def fd_exp_pts_allowed
    starter_innings = self.zips_ip / self.zips_games.to_f
    starter_pts = (self.zips_doubles * 1 + self.zips_triples * 2 + self.zips_homers * 3 + self.zips_er * 1.034 + self.zips_er * 1.09 +
      self.zips_whip * self.zips_ip + 0.063 * self.zips_ip * 2 + self.zips_ip * 3.0 * -0.25) / self.zips_ip * starter_innings
    relievers = Pitcher.where(team_id: self.team_id, reliever: true)
    doubles_counter = 0
    triples_counter = 0
    homers_counter = 0
    er_counter = 0
    baserunners_counter = 0
    ip_counter = 0
    relievers.each do |r|
      doubles_counter += r.zips_doubles
      triples_counter += r.zips_triples
      homers_counter += r.zips_homers
      er_counter += r.zips_er
      baserunners_counter += r.zips_whip * r.zips_ip
      ip_counter += r.zips_ip
    end
    reliever_pts = (doubles_counter * 1 + triples_counter * 2 + homers_counter * 3 + er_counter * 1.034 + er_counter * 1.09 +
      baserunners_counter + 0.063 * ip_counter * 2 + ip_counter * 3.0 * -0.25) / ip_counter * (9 - starter_innings)
    total_pts = starter_pts + reliever_pts
    if self.team.park_factor > 1
      total_pts = total_pts / ((self.team.fd_park_factor - 1) / 2 + 1)
    else
      total_pts = total_pts / (1 - (1 - self.team.fd_park_factor) / 2)
    end
    total_pts
  end

  def dk_exp_pts_allowed
    starter_innings = self.zips_ip / self.zips_games.to_f
    starter_pts = (self.zips_singles * 3 + self.zips_doubles * 5 + self.zips_triples * 8 + self.zips_homers * 10 + self.zips_er * 1.034 * 2 + self.zips_er * 1.09 * 2 +
      self.zips_bb_hbp * self.zips_ip * 2 + 0.063 * self.zips_ip * 5 + 0.0235 * zips_ip * -2 ) / self.zips_ip * starter_innings
    relievers = Pitcher.where(team_id: self.team_id, reliever: true)
    singles_counter = 0
    doubles_counter = 0
    triples_counter = 0
    homers_counter = 0
    er_counter = 0
    bb_hbp_counter = 0
    ip_counter = 0
    relievers.each do |r|
      singles_counter += r.zips_singles
      doubles_counter += r.zips_doubles
      triples_counter += r.zips_triples
      homers_counter += r.zips_homers
      er_counter += r.zips_er
      bb_hbp_counter += r.zips_bb_hbp * r.zips_ip
      ip_counter += r.zips_ip
    end
    reliever_pts = (singles_counter * 3 + doubles_counter * 5 + triples_counter * 8 + homers_counter * 10 + er_counter * 1.034 * 2 + er_counter * 1.09 * 2 +
      bb_hbp_counter * 2 + 0.063 * ip_counter * 5 + 0.0235 * ip_counter * -2) / ip_counter * (9 - starter_innings)
    total_pts = starter_pts + reliever_pts
    if self.team.park_factor > 1
      total_pts = total_pts / ((self.team.park_factor - 1) / 2 + 1)
    else
      total_pts = total_pts / (1 - (1 - self.team.park_factor) / 2)
    end
    total_pts
  end

  def opponent
    game = Matchup.where("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id).where(day: Date.today).first
    return if game.nil?
    if game.visitor_id == self.team_id
      opp_team = "@ " + game.home.name
    elsif game.home_id == self.team_id
      opp_team = game.visitor.name
    end
    opp_team
  end

end
