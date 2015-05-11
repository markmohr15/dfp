# == Schema Information
#
# Table name: pitchers
#
#  id            :integer          not null, primary key
#  name          :string
#  wins          :integer
#  games         :integer
#  gs            :integer
#  ip            :integer
#  er            :integer
#  so            :integer
#  whip          :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fd_salary     :integer
#  fd_season_ppg :float
#  reliever      :boolean          default("false")
#  homers        :integer
#  hits          :integer
#  team_id       :integer
#  selected      :boolean
#
# Indexes
#
#  index_pitchers_on_team_id  (team_id)
#

class Pitcher < ActiveRecord::Base

  has_many :batters
  belongs_to :team

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

  def self.get_zips_pitcher_data  #mass import
    agent = Mechanize.new
    stuff = []
    for i in 1..30
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgRow")
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=pit&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgAltRow")
    end
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    data.each do |x|
      Pitcher.create(name: x[0].join(","), team_id: (Team.where(name: x[1].join(",")).first_or_create).id, wins: x[2].join(","), games: x[6].join(","), gs: x[5].join(","), ip: x[7].join(","), hits: x[8].join(","), er: x[9].join(","), homers: x[10].join(","), so: x[11].join(","), whip: x[13].join(",") )
    end
  end

  def self.get_zips_one_pitcher_data url, pitcher, team #indiv with zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projectionsin_show")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Pitcher.create(name: pitcher, team_id: Team.find_by(name: team).id, wins: data[3][2][0], games: data[3][5][0], gs: data[3][6][0], ip: data[3][12][0], hits: data[3][14][0], er: data[3][16][0], homers: data[3][17][0], so: data[3][23][0], whip: data[6][10][0] )
  end

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def fd_pts_per_game
    season_pts = self.wins * 4 + self.er * -1 + self.so * 1 + self.ip * 1
    season_pts / self.games.to_f
  end

  def fd_pts_per_1000_dollars
    if self.fd_salary.blank?
      "N/A"
    else
      sprintf('%.2f', self.fd_pts_per_game / self.fd_salary * 1000)
    end
  end

  def self.sorted_by_fd_pts_per_1000_dollars
    Pitcher.where("fd_salary > 0").sort_by(&:fd_pts_per_1000_dollars).reverse!
  end

  def non_homers
    self.hits - self.homers
  end

  def singles
    self.non_homers * 0.75
  end

  def doubles
    self.non_homers * 0.225
  end

  def triples
    self.non_homers * 0.025
  end

  def fd_exp_pts_allowed
    starter_innings = self.ip / self.games.to_f
    starter_pts = (self.doubles * 1 + self.triples * 2 + self.homers * 3 + self.er * 1.034 + self.er * 1.09 +
      self.whip * self.ip + 0.063 * self.ip * 2 + ip * 3.0 * -0.25) / self.ip * starter_innings
    relievers = Pitcher.where(team_id: self.team_id, reliever: true)
    doubles_counter = 0
    triples_counter = 0
    homers_counter = 0
    er_counter = 0
    baserunners_counter = 0
    ip_counter = 0
    relievers.each do |r|
      doubles_counter += r.doubles
      triples_counter += r.triples
      homers_counter += r.homers
      er_counter += r.er
      baserunners_counter += r.whip * r.ip
      ip_counter += r.ip
    end
    reliever_pts = (doubles_counter * 1 + triples_counter * 2 + homers_counter * 3 + er_counter * 1.034 + er_counter * 1.09 +
      baserunners_counter + 0.063 * ip_counter * 2 + ip_counter * 3.0 * -0.25) / ip_counter * (9 - starter_innings)
    total_pts = starter_pts + reliever_pts
    if self.team.park_factor > 1
      total_pts = total_pts / (self.team.park_factor + 1) * self.team.park_factor
    else
      total_pts = total_pts / self.team.park_factor
    end
    total_pts * self.park_factor
  end

  def opponent
    game = Matchup.find_by("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id)
    return if game.nil?
    if game.visitor_id == self.team_id
      opp_team = "@ " + game.home.name
    elsif game.home_id == self.team_id
      opp_team = game.visitor.name
    end
    opp_team
  end

end
