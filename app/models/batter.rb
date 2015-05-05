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
#  adj_fd_ppg    :float
#  lineup_spot   :integer
#  selected      :boolean
#
# Indexes
#
#  index_batters_on_pitcher_id  (pitcher_id)
#  index_batters_on_team_id     (team_id)
#

class Batter < ActiveRecord::Base

  belongs_to :pitcher
  belongs_to :team

  before_save :set_adj_fd_ppg

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def papg #plate app/game
    case self.lineup_spot
    when 1
      4.649
    when 2
      4.538
    when 3
      4.427
    when 4
      4.316
    when 5
      4.205
    when 6
      4.094
    when 7
      3.983
    when 8
      3.872
    when 9
      3.761
    else
      0
    end
  end

  def fd_pts_per_game
    season_pts = self.hits * 1 + self.doubles * 1 + self.triples * 2 + self.homers * 3 + self.rbis * 1 +
     self.runs * 1 + self.walks * 1 + self.sb * 2 + self.hbps * 1 + (ab - hits) * -0.25
    season_pts / pa * self.papg
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

  def set_adj_fd_ppg
    if self.pitcher.blank?
      self.adj_fd_ppg = 0
    else
      self.adj_fd_ppg = (self.pitcher.fd_exp_pts_allowed / 20.4 * self.fd_pts_per_game).round(2)
    end
  end

  def self.catchers_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "C", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.firstbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "1B", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.secondbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "2B", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.thirdbasemen_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "3B", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.shortstops_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "SS", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.outfielders_sorted_by_adj_fd_pts_per_1000_dollars
    Batter.where("fd_salary > ? and position = ? and lineup_spot > ?", 0, "OF", 0).sort_by(&:adj_fd_pts_per_1000_dollars).reverse!
  end

  def self.get_lineups
    agent = Mechanize.new
    stuff = agent.get("http://www.baseballpress.com/lineups").search('.players')
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    adds = []
    Batter.update_all lineup_spot: nil
    data.flatten.each do |x|
      if x[-1] == "P"
      else
        b = Batter.find_by(name: x.split[1..2].join(" "))
        unless b.nil?
          b.lineup_spot = x[0]
          b.save
        else
          adds << x.split[1..2].join(" ")
        end
      end
    end
    adds
  end

  def self.get_fd_data url
    agent = Mechanize.new
    stuff = agent.get(url).search(".pR")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.update_all fd_salary: nil
    Pitcher.update_all fd_salary: nil
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

  def self.get_zips_batter_data  #mass import
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
      batter = Batter.where(name: x[0].join(",")).first_or_initialize
      batter.update_attributes(team_id: (Team.where(name: x[1].join(",")).first_or_create).id, pa: x[3].join(","), ab: x[4].join(","), hits: x[5].join(","), doubles: x[6].join(","), triples: x[7].join(","), homers: x[8].join(","), runs: x[9].join(","), rbis: x[10].join(","), walks: x[11].join(","), hbps: x[13].join(","), sb: x[14].join(","), cs: x[15].join(",") )
    end
  end

  def self.get_zips_one_batter_hidden url, batter, team, position #indiv import with no zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projections_hide")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.create(name: batter, position: position, team_id: (Team.where(name: team).first_or_create).id, pa: data[7][4][0], ab: data[7][3][0], hits: data[7][5][0], doubles: data[7][7][0], triples: data[7][8][0], homers: data[7][9][0], runs: data[7][10][0], rbis: data[7][11][0], walks: data[7][12][0], hbps: data[7][15][0], sb: data[7][19][0], cs: data[7][20][0] )
  end

  def self.get_zips_one_batter_data url, batter, team, position #indiv import with
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projectionsin_show")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.create(name: batter, position: position, team_id: (Team.where(name: team).first_or_create).id, pa: data[3][4][0], ab: data[3][3][0], hits: data[3][5][0], doubles: data[3][7][0], triples: data[3][8][0], homers: data[3][9][0], runs: data[3][10][0], rbis: data[3][11][0], walks: data[3][12][0], hbps: data[3][15][0], sb: data[3][19][0], cs: data[3][20][0] )
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

  def self.optimal_fd
    catchers = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "C", true, 0, 0)
    firsts = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "1B", true, 0, 0)
    seconds = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "2B", true, 0, 0)
    thirds = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "3B", true, 0, 0)
    shorts = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "SS", true, 0, 0)
    ofs = Batter.where("position = ? and selected = ? and pitcher_id > ? and lineup_spot > ?", "OF", true, 0, 0)
    pitchers = Pitcher.where("fd_salary > ? and selected = ?", 0, true)
    pts_counter = 0
    salary_counter = 0
    roster = []
    high_score = 0
    team = ""
    high_salary = 0
    catchers.each do |c|
      roster << c.name
      pts_counter += c.adj_fd_ppg
      salary_counter += c.fd_salary
      firsts.each do |f|
        roster << f.name
        pts_counter += f.adj_fd_ppg
        salary_counter += f.fd_salary
        seconds.each do |s|
          roster << s.name
          pts_counter += s.adj_fd_ppg
          salary_counter += s.fd_salary
          thirds.each do |t|
            roster << t.name
            pts_counter += t.adj_fd_ppg
            salary_counter += t.fd_salary
            shorts.each do |ss|
              roster << ss.name
              pts_counter += ss.adj_fd_ppg
              salary_counter += ss.fd_salary
              ofs.each do |ofa|
                roster << ofa.name
                pts_counter += ofa.adj_fd_ppg
                salary_counter += ofa.fd_salary
                ofs.each do |ofb|
                  roster << ofb.name
                  pts_counter += ofb.adj_fd_ppg
                  salary_counter += ofb.fd_salary
                  ofs.each do |ofc|
                    roster << ofc.name
                    pts_counter += ofc.adj_fd_ppg
                    salary_counter += ofc.fd_salary
                    pitchers.each do |p|
                      roster << p.name
                      pts_counter += p.fd_pts_per_game
                      salary_counter += p.fd_salary
                      if salary_counter <= 35000 && pts_counter > high_score && roster.uniq.length == roster.length
                        high_score = pts_counter
                        team = roster.join(", ")
                        high_salary = salary_counter
                      end
                      roster.pop
                      pts_counter -= p.fd_pts_per_game
                      salary_counter -= p.fd_salary
                    end
                    roster.pop
                    pts_counter -= ofc.adj_fd_ppg
                    salary_counter -= ofc.fd_salary
                  end
                  roster.pop
                  pts_counter -= ofb.adj_fd_ppg
                  salary_counter -= ofb.fd_salary
                end
                roster.pop
                pts_counter -= ofa.adj_fd_ppg
                salary_counter -= ofa.fd_salary
              end
              roster.pop
              pts_counter -= ss.adj_fd_ppg
              salary_counter -= ss.fd_salary
            end
            roster.pop
            pts_counter -= t.adj_fd_ppg
            salary_counter -= t.fd_salary
          end
          roster.pop
          pts_counter -= s.adj_fd_ppg
          salary_counter -= s.fd_salary
        end
        roster.pop
        pts_counter -= f.adj_fd_ppg
        salary_counter -= f.fd_salary
      end
      roster.pop
      pts_counter -= c.adj_fd_ppg
      salary_counter -= c.fd_salary
    end
    team + " " + high_score.round(2).to_s + " $" + high_salary.to_s
  end
end








