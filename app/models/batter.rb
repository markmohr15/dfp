# == Schema Information
#
# Table name: batters
#
#  id            :integer          not null, primary key
#  name          :string
#  position      :text
#  pa            :integer
#  ab            :integer
#  hits          :integer
#  doubles       :integer
#  triples       :integer
#  homers        :integer
#  runs          :integer
#  rbis          :integer
#  walks         :integer
#  hbps          :integer
#  sb            :integer
#  cs            :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fd_salary     :integer
#  fd_season_ppg :float
#  pitcher_id    :integer
#  team_id       :integer
#

class Batter < ActiveRecord::Base

  belongs_to :pitcher
  belongs_to :team

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def fd_pts_per_game
    season_pts = self.hits * 1 + self.doubles * 1 + self.triples * 2 + self.homers * 3 + self.rbis * 1 +
     self.runs * 1 + self.walks * 1 + self.sb * 2 + self.hbps * 1 + (ab - hits) * -0.25
    season_pts / pa * 4.25
  end

  def fd_pts_per_1000_dollars
    if self.fd_salary.blank?
      "N/A"
    else
      (self.fd_pts_per_game / self.fd_salary * 1000).round(2)
    end
  end

  def adj_fd_pts_per_game
    if self.pitcher.blank?
      "N/A"
    else
      (self.pitcher.fd_exp_pts_allowed / 20.4 * self.fd_pts_per_game).round(2)
    end
  end

  def adj_fd_pts_per_1000_dollars
    if self.fd_salary.blank? || self.pitcher.blank?
      "N/A"
    else
      sprintf('%.2f', self.adj_fd_pts_per_game.to_f / self.fd_salary * 1000)
    end
  end

  def self.catchers_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "C").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.firstbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "1B").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.secondbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "2B").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.thirdbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "3B").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.shortstops_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "SS").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.outfielders_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ?", 0, "OF").sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.get_fd_data url
    agent = Mechanize.new
    stuff = agent.get(url).search(".pR")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.all.each do |batter|
      batter.fd_salary = nil
      batter.save
    end
    Pitcher.all.each do |pitcher|
      pitcher.fd_salary = nil
      pitcher.save
    end
    data.each do |x|
      if x[0].join(",") == "P"
        p = Pitcher.find_by(name: (x[1].join(","))[0...-1])
        unless p.nil?
          p.update_attributes(fd_salary: (x[5].join(","))[1..-1].gsub(",", "").to_i, starting: true, fd_season_ppg: x[2].join(","))
        end
      else
        b = Batter.find_by(name: x[1].join(","))
        unless b.nil?
          b.update_attributes(position: x[0].join(","), fd_salary: (x[5].join(","))[1..-1].gsub(",", "").to_i, fd_season_ppg: x[2].join(","))
          b.get_pitcher_id
        end
      end
    end
  end

  def self.get_zips_batter_data
    agent = Mechanize.new
    stuff = []
    for i in 1..30
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgRow")
      stuff += agent.get('http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=rzips&team=' + i.to_s + '&lg=all&players=0').search(".rgAltRow")
    end
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    data.each do |x|
      Batter.create(name: x[0].join(","), team_id: (Team.where(name: x[1].join(",")).first_or_create).id, pa: x[3].join(","), ab: x[4].join(","), hits: x[5].join(","), doubles: x[6].join(","), triples: x[7].join(","), homers: x[8].join(","), runs: x[9].join(","), rbis: x[10].join(","), walks: x[11].join(","), hbps: x[13].join(","), sb: x[14].join(","), cs: x[15].join(",") )
    end
  end

  def get_pitcher_id
    game = Matchup.find_by("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id)
    return if game.nil?
    if game.visitor_id == self.team_id
      opp_team_id = game.home_id
    elsif game.home_id == self.team_id
      opp_team_id = game.visitor_id
    end
    self.pitcher = Pitcher.find_by("team_id in (?) and fd_salary > ?", opp_team_id, 0)
    self.save
  end

end
