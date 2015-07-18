# == Schema Information
#
# Table name: batters
#
#  id                       :integer          not null, primary key
#  name                     :string
#  position                 :text
#  zips_pa                  :integer
#  zips_ab                  :integer
#  zips_hits                :integer
#  zips_doubles             :integer
#  zips_triples             :integer
#  zips_homers              :integer
#  zips_runs                :integer
#  zips_rbis                :integer
#  zips_walks               :integer
#  zips_hbps                :integer
#  zips_sb                  :integer
#  zips_cs                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  fd_salary                :integer
#  fd_season_ppg            :float
#  pitcher_id               :integer
#  team_id                  :integer
#  zips_adj_fd_ppg          :float
#  lineup_spot              :integer
#  selected                 :boolean
#  rh_overnight_lineup_spot :integer
#  lh_overnight_lineup_spot :integer
#  zips_pa_rhp              :integer
#  zips_ab_rhp              :integer
#  zips_hits_rhp            :integer
#  zips_doubles_rhp         :integer
#  zips_triples_rhp         :integer
#  zips_homers_rhp          :integer
#  zips_rbis_rhp            :integer
#  zips_walks_rhp           :integer
#  zips_hbps_rhp            :integer
#  zips_pa_lhp              :integer
#  zips_ab_lhp              :integer
#  zips_hits_lhp            :integer
#  zips_doubles_lhp         :integer
#  zips_triples_lhp         :integer
#  zips_homers_lhp          :integer
#  zips_rbis_lhp            :integer
#  zips_walks_lhp           :integer
#  zips_hbps_lhp            :integer
#  pa_rhp                   :integer
#  ab_rhp                   :integer
#  hits_rhp                 :integer
#  doubles_rhp              :integer
#  triples_rhp              :integer
#  homers_rhp               :integer
#  rbis_rhp                 :integer
#  walks_rhp                :integer
#  hbps_rhp                 :integer
#  pa_lhp                   :integer
#  ab_lhp                   :integer
#  hits_lhp                 :integer
#  doubles_lhp              :integer
#  triples_lhp              :integer
#  homers_lhp               :integer
#  rbis_lhp                 :integer
#  walks_lhp                :integer
#  hbps_lhp                 :integer
#  pa                       :integer
#  ab                       :integer
#  hits                     :integer
#  doubles                  :integer
#  triples                  :integer
#  homers                   :integer
#  runs                     :integer
#  rbis                     :integer
#  walks                    :integer
#  hbps                     :integer
#  sb                       :integer
#  cs                       :integer
#  fd_alias                 :string
#  fg_alias                 :string
#
# Indexes
#
#  index_batters_on_pitcher_id  (pitcher_id)
#  index_batters_on_team_id     (team_id)
#

class Batter < ActiveRecord::Base

  belongs_to :pitcher
  belongs_to :team

  before_save :set_zips_adj_fd_ppg, :remove_from_lineup

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def remove_from_lineup
    batter = Batter.find_by(team_id: self.team_id, lineup_spot: self.lineup_spot)
    return if batter.nil?
    return if batter == self
    batter.lineup_spot = nil
    batter.save
  end

  def park_factor
    game = Matchup.where("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id).where(day: Date.today).first
    if game.nil? || self.pitcher.nil?
      1
    elsif game.visitor_id == self.team_id
      self.pitcher.team.park_factor
    elsif game.home_id == self.team_id
      self.team.park_factor
    end
  end

  def fd_park_factor
    game = Matchup.where("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id).where(day: Date.today).first
    if game.nil? || self.pitcher.nil?
      1
    elsif game.visitor_id == self.team_id
      self.pitcher.team.fd_park_factor
    elsif game.home_id == self.team_id
      self.team.fd_park_factor
    end
  end

  def papg #plate app/game
    case self.lineup_spot
    when 1
      avg = 4.649
    when 2
      avg = 4.538
    when 3
      avg = 4.427
    when 4
      avg = 4.316
    when 5
      avg = 4.205
    when 6
      avg = 4.094
    when 7
      avg = 3.983
    when 8
      avg = 3.872
    when 9
      avg = 3.761
    else
      avg = 0
    end
    if self.team.home?
      avg * 0.981
    else
      avg * 1.019
    end
  end

  def nine_inning_papg #plate app/game
    case self.lineup_spot
    when 1
      avg = 4.649
    when 2
      avg = 4.538
    when 3
      avg = 4.427
    when 4
      avg = 4.316
    when 5
      avg = 4.205
    when 6
      avg = 4.094
    when 7
      avg = 3.983
    when 8
      avg = 3.872
    when 9
      avg = 3.761
    else
      avg = 0
    end
  end

  def overnight_nine_inning_papg spot #plate app/game
    case spot
    when 1
      avg = 4.649
    when 2
      avg = 4.538
    when 3
      avg = 4.427
    when 4
      avg = 4.316
    when 5
      avg = 4.205
    when 6
      avg = 4.094
    when 7
      avg = 3.983
    when 8
      avg = 3.872
    when 9
      avg = 3.761
    else
      avg = 0
    end
  end

  def zips_singles
    self.zips_hits - self.zips_doubles - self.zips_triples - self.zips_homers
  end

  def zips_singles_lhp
    self.zips_hits_lhp - self.zips_doubles_lhp - self.zips_triples_lhp - self.zips_homers_lhp
  end

  def zips_singles_rhp
    self.zips_hits_rhp - self.zips_doubles_rhp - self.zips_triples_rhp - self.zips_homers_rhp
  end

  def self.ballpark
    agent = Mechanize.new
    stuff = agent.get("http://www.baseball-reference.com/leagues/split.cgi?t=b&year=2013&lg=MLB#lineu").search('tr')
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    morestuff = agent.get("http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2013&month=16&season1=&ind=0&team=0,ts&rost=&age=0&filter=&players=0").search(".rgRow") + agent.get("http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2013&month=16&season1=&ind=0&team=0,ts&rost=&age=0&filter=&players=0").search(".rgAltRow")
    moredata = morestuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    parks = []
    parks << data[256]
    parks << data[257]
    parks << data[258]
    parks << data[259]
    parks << data[260]
    parks << data[261]
    parks << data[262]
    parks << data[263]
    parks << data[264]
    parks << data[265]
    parks << data[266]
    parks << data[267]
    parks << data[268]
    parks << data[269]
    parks << data[270]
    parks << data[271]
    parks << data[272]
    parks << data[273]
    parks << data[274]
    parks << data[275]
    parks << data[276]
    parks << data[277]
    parks << data[278]
    parks << data[279]
    parks << data[280]
    parks << data[281]
    parks << data[282]
    parks << data[283]
    parks << data[284]
    parks << data[285]
    counter = 0
    parks.each do |x|
      if x[0][0] == "TEX-Rangers Bpk" || x[0][0] == "SFG-AT&T Pk"
        home_fdpg = (x[5][0].to_i + x[6][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[10][0].to_i +
        x[11][0].to_i * 2 + x[13][0].to_i + x[21][0].to_i + (x[4][0].to_i - x[6][0].to_i) * -0.25) / 82.0
      elsif x[0][0] == "CIN-GreatAmer BP"
        home_fdpg = (x[5][0].to_i + x[6][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[10][0].to_i +
        x[11][0].to_i * 2 + x[13][0].to_i + x[21][0].to_i + (x[4][0].to_i - x[6][0].to_i) * -0.25) / 80.0
      else
        home_fdpg = (x[5][0].to_i + x[6][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[10][0].to_i +
        x[11][0].to_i * 2 + x[13][0].to_i + x[21][0].to_i + (x[4][0].to_i - x[6][0].to_i) * -0.25) / 81.0
      end
      puts x[0][0].to_s + " " + home_fdpg.to_s
    end
    moredata.each do |x|
      if x[1][0] == "Reds"
        away_fdopg = (x[5][0].to_i + x[10][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[11][0].to_i +
        x[19][0].to_i * 2 + x[12][0].to_i + x[15][0].to_i + (x[3][0].to_i - x[5][0].to_i) * -0.25) / 82.0
        puts x[1][0] + " " + away_fdopg.to_s
      elsif x[1][0] == "Giants"
        away_fdopg = (x[5][0].to_i + x[10][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[11][0].to_i +
        x[19][0].to_i * 2 + x[12][0].to_i + x[15][0].to_i + (x[3][0].to_i - x[5][0].to_i) * -0.25) / 80.0
        puts x[1][0] + " " + away_fdopg.to_s
      elsif x[1][0] == "Rays"
        away_fdopg = (x[5][0].to_i + x[10][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[11][0].to_i +
        x[19][0].to_i * 2 + x[12][0].to_i + x[15][0].to_i + (x[3][0].to_i - x[5][0].to_i) * -0.25) / 82.0
        puts x[1][0] + " " + away_fdopg.to_s
      else
        away_fdopg = (x[5][0].to_i + x[10][0].to_i + x[7][0].to_i + x[8][0].to_i * 2 + x[9][0].to_i * 3 + x[11][0].to_i +
        x[19][0].to_i * 2 + x[12][0].to_i + x[15][0].to_i + (x[3][0].to_i - x[5][0].to_i) * -0.25) / 81.0
        puts x[1][0] + " " + away_fdopg.to_s
      end
    end
    true
  end

  def zips_fd_pts_per_game_park_neutral
    ppg = 0
    unless self.zips_pa_rhp.blank?
      if self.pitcher.throws == "right"
        season_pts = self.zips_hits_rhp * 1 + self.zips_doubles_rhp * 1 + self.zips_triples_rhp * 2 + self.zips_homers_rhp * 3 + self.zips_rbis_rhp * 1 +
        + self.zips_walks_rhp * 1 + self.zips_hbps_rhp * 1 + (self.zips_ab_rhp - self.zips_hits_rhp) * -0.25
        ppg = season_pts / self.zips_pa_rhp.to_f * self.papg * 2 / 3
      else
        season_pts = self.zips_hits_lhp * 1 + self.zips_doubles_lhp * 1 + self.zips_triples_lhp * 2 + self.zips_homers_lhp * 3 + self.zips_rbis_lhp * 1 +
        + self.zips_walks_lhp * 1 + self.zips_hbps_lhp * 1 + (self.zips_ab_lhp - self.zips_hits_lhp) * -0.25
        ppg = season_pts / self.zips_pa_rhp.to_f * self.papg * 2 / 3
      end
      ppg += (self.zips_runs * 1 + self.zips_sb * 2) / self.zips_pa.to_f * self.papg
      season_pts = self.zips_hits * 1 + self.zips_doubles * 1 + self.zips_triples * 2 + self.zips_homers * 3 + self.zips_rbis * 1 +
       self.zips_runs * 1 + self.zips_walks * 1 + self.zips_sb * 2 + self.zips_hbps * 1 + (self.zips_ab - self.zips_hits) * -0.25
      ppg += season_pts / self.zips_pa.to_f * self.papg / 3
    else
      season_pts = self.zips_hits * 1 + self.zips_doubles * 1 + self.zips_triples * 2 + self.zips_homers * 3 + self.zips_rbis * 1 +
       self.zips_runs * 1 + self.zips_walks * 1 + self.zips_sb * 2 + self.zips_hbps * 1 + (self.zips_ab - self.zips_hits) * -0.25
      ppg += season_pts / self.zips_pa.to_f * self.papg
    end
    if self.team.park_factor > 1
      ppg = ppg / ((self.team.park_factor - 1) / 2 + 1)
    else
      ppg = ppg / (1 - (1 - self.team.park_factor) / 2)
    end
    ppg.round(2)
  end

  def zips_fd_pts_per_game_park_adj
    (self.zips_fd_pts_per_game_park_neutral * self.fd_park_factor).round(2)
  end

  def ytd_fd_pts_per_1000_dollars
    (self.fd_season_ppg / self.fd_salary * 1000).round(2)
  end

  def zips_fd_pts_per_1000_dollars_park_neutral
    if self.fd_salary.blank?
      "N/A"
    else
      (self.zips_fd_pts_per_game_park_neutral / self.fd_salary * 1000).round(2)
    end
  end

  def adj_fd_pts_per_1000_dollars
    if self.fd_salary.blank? || self.pitcher.blank?
      "N/A"
    else
      sprintf('%.2f', self.zips_adj_fd_ppg.to_f / self.fd_salary * 1000)
    end
  end

  def set_zips_adj_fd_ppg
    if self.pitcher.blank?
      self.zips_adj_fd_ppg = 0
    else
      self.zips_adj_fd_ppg = (self.pitcher.fd_exp_pts_allowed / 19.072 * self.zips_fd_pts_per_game_park_adj).round(2)
    end
    if self.team.home?
      self.zips_adj_fd_ppg *= 1.0337
    else
      self.zips_adj_fd_ppg *= 0.9663
    end
    self.zips_adj_fd_ppg = self.zips_adj_fd_ppg.round(2)
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
        b = Batter.find_by(name: x[2..-1].split("(")[0][1..-2])
        unless b.nil?
          b.lineup_spot = x[0]
          b.save
        else
          adds << x[2..-1].split("(")[0][1..-2]
        end
      end
    end
    adds
  end

  def self.get_fd_data game
    Batter.update_all fd_salary: nil
    Pitcher.update_all fd_salary: nil
    game_id = game
    curl_req = `curl 'https://api.fanduel.com/fixture-lists/#{game_id}/players' -H 'Origin: https://www.fanduel.com' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Authorization: Basic N2U3ODNmMTE4OTIzYzE2NzVjNWZhYWFmZTYwYTc5ZmM6' -H 'Accept: application/json, text/plain, */*' -H 'Cache-Control: max-age=0' -H 'X-Auth-Token: 0aaafb0a611f4c0f1cebeb642f824e2cbff48f787959b7892fa61425981c5189' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'Connection: keep-alive' -H 'Referer: https://www.fanduel.com/games/12627/contests/12627-13656597/enter' --compressed`
    my_hash = JSON.parse(curl_req)
    players = my_hash["players"]
    players.each do |x|
      #binding.pry
      if x["position"] == "P" && x["probable_pitcher"] == true
        p = Pitcher.find_by(name: x["first_name"] + " " + x["last_name"])
        if p.nil?
          p = Pitcher.find_by(fd_alias: x["first_name"] + " " + x["last_name"])
        end
        unless p.nil?
          p.update_attributes(fd_salary: x["salary"], fd_season_ppg: x["fppg"].round(1))
        end
      else
        b = Batter.find_by(name: x["first_name"] + " " + x["last_name"])
        if b.nil?
          b = Batter.find_by(fd_alias: x["first_name"] + " " + x["last_name"])
        end
        unless b.nil?
          b.update_attributes(position: x["position"], fd_salary: x["salary"], fd_season_ppg: x["fppg"].round(1))
          b.get_pitcher_id
        end
      end
    end
    true
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
      batter.update_attributes(team_id: (Team.where(name: x[1].join(",")).first_or_create).id, zips_pa: x[3].join(","), zips_ab: x[4].join(","), zips_hits: x[5].join(","), zips_doubles: x[6].join(","), zips_triples: x[7].join(","), zips_homers: x[8].join(","), zips_runs: x[9].join(","), zips_rbis: x[10].join(","), zips_walks: x[11].join(","), zips_hbps: x[13].join(","), zips_sb: x[14].join(","), zips_cs: x[15].join(",") )
    end
  end

  def self.get_stats pages
    agent = Mechanize.new
    stuff = []
    for i in 1..pages
      stuff += agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=13&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgRow") + agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=13&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgAltRow")
    end
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    not_found = []
    lhp_counter = 0
    rhp_counter = 0
    total_counter = 0
    data.each do |x|
      batter = Batter.find_by(name: x[1][0])
      if batter.nil?
        batter = Batter.find_by(fg_alias: x[1][0])
        if batter.nil?
          pitcher = Pitcher.find_by(name: x[1][0])
          if pitcher.nil?
            not_found << x[1][0]
          end
        end
      end
      if batter.nil?
      else
        lhp_counter += 1
        batter.update_attributes(pa_lhp: x[5][0], ab_lhp: x[4][0], hits_lhp: x[6][0], doubles_lhp: x[8][0], triples_lhp: x[9][0], homers_lhp: x[10][0], rbis_lhp: x[12][0], walks_lhp: x[13][0], hbps_lhp: x[16][0] )
      end
    end
    morestuff = []
    for i in 1..pages
      morestuff += agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=14&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgRow") + agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=14&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgAltRow")
    end
    moredata = morestuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    moredata.each do |x|
      batter = Batter.find_by(name: x[1][0])
      if batter.nil?
        batter = Batter.find_by(fg_alias: x[1][0])
        if batter.nil?
          pitcher = Pitcher.find_by(name: x[1][0])
          if pitcher.nil?
            not_found << x[1][0]
          end
        end
      end
      if batter.nil?
      else
        rhp_counter += 1
        batter.update_attributes(pa_rhp: x[5][0], ab_rhp: x[4][0], hits_rhp: x[6][0], doubles_rhp: x[8][0], triples_rhp: x[9][0], homers_rhp: x[10][0], rbis_rhp: x[12][0], walks_rhp: x[13][0], hbps_rhp: x[16][0] )
      end
    end
    evenmorestuff = []
    for i in 1..pages
      evenmorestuff += agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=0&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgRow") + agent.get('http://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=0&type=0&season=2015&month=0&season1=2015&ind=0&team=0&rost=0&age=0&filter=&players=0&page=' + i.to_s + '_30').search(".rgAltRow")
    end
    evenmoredata = evenmorestuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    evenmoredata.each do |x|
      batter = Batter.find_by(name: x[1][0])
      if batter.nil?
        batter = Batter.find_by(fg_alias: x[1][0])
        if batter.nil?
          pitcher = Pitcher.find_by(name: x[1][0])
          if pitcher.nil?
            not_found << x[1][0]
          end
        end
      end
      if batter.nil?
      else
        total_counter +=1
        batter.update_attributes(pa: x[5][0], ab: x[4][0], hits: x[6][0], doubles: x[8][0], triples: x[9][0], homers: x[10][0], runs: x[11][0], rbis: x[12][0], walks: x[13][0], hbps: x[16][0], sb: x[20][0], cs: x[21][0])
      end
    end
    not_found << lhp_counter
    not_found << rhp_counter
    not_found << total_counter
    not_found.uniq
  end

  def self.get_zips_one_batter_hidden url, batter, team, position, row #indiv import with no zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projections_hide")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.create(name: batter, position: position, team_id: (Team.where(name: team).first_or_create).id, zips_pa: data[row][4][0], zips_ab: data[row][3][0], zips_hits: data[row][5][0], zips_doubles: data[row][7][0], zips_triples: data[row][8][0], zips_homers: data[row][9][0], zips_runs: data[row][10][0], zips_rbis: data[row][11][0], zips_walks: data[row][12][0], zips_hbps: data[row][15][0], zips_sb: data[row][19][0], zips_cs: data[row][20][0] )
  end

  def self.get_zips_one_batter_data url, batter, team, position, row #indiv import with zips on page
    agent = Mechanize.new
    stuff = agent.get(url).search(".grid_projectionsin_show")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.create(name: batter, position: position, team_id: (Team.where(name: team).first_or_create).id, zips_pa: data[row][4][0], zips_ab: data[row][3][0], zips_hits: data[row][5][0], zips_doubles: data[row][7][0], zips_triples: data[row][8][0], zips_homers: data[row][9][0], zips_runs: data[row][10][0], zips_rbis: data[row][11][0], zips_walks: data[row][12][0], zips_hbps: data[row][15][0], zips_sb: data[row][19][0], zips_cs: data[row][20][0] )
  end

  def self.use_season_stats_for_zips url, batter, team, position, row
    agent = Mechanize.new
    stuff = agent.get(url).search(".rgRow")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    Batter.create(name: batter, position: position, team_id: (Team.where(name: team).first_or_create).id, zips_pa: data[row][4][0], zips_ab: data[row][3][0], zips_hits: data[row][5][0], zips_doubles: data[row][7][0], zips_triples: data[row][8][0], zips_homers: data[row][9][0], zips_runs: data[row][10][0], zips_rbis: data[row][11][0], zips_walks: data[row][12][0], zips_hbps: data[row][15][0], zips_sb: data[row][19][0], zips_cs: data[row][20][0] )
  end

  def get_pitcher_id
    game = Matchup.where("visitor_id in (?) or home_id in (?)", self.team_id, self.team_id).where(day: Date.today).first
    return if game.nil?
    if game.visitor_id == self.team_id
      self.pitcher = game.home_pitcher
    else
      self.pitcher = game.visiting_pitcher
    end
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
    team_array = []
    high_score = 0
    team = ""
    high_salary = 0
    catchers.each do |c|
      roster << c.name
      team_array << c.team.name
      pts_counter += c.zips_adj_fd_ppg
      salary_counter += c.fd_salary
      firsts.each do |f|
        roster << f.name
        team_array << f.team.name
        pts_counter += f.zips_adj_fd_ppg
        salary_counter += f.fd_salary
        seconds.each do |s|
          roster << s.name
          team_array << s.team.name
          pts_counter += s.zips_adj_fd_ppg
          salary_counter += s.fd_salary
          thirds.each do |t|
            roster << t.name
            team_array << t.team.name
            pts_counter += t.zips_adj_fd_ppg
            salary_counter += t.fd_salary
            shorts.each do |ss|
              roster << ss.name
              team_array << ss.team.name
              pts_counter += ss.zips_adj_fd_ppg
              salary_counter += ss.fd_salary
              ofs.each do |ofa|
                roster << ofa.name
                team_array << ofa.team.name
                pts_counter += ofa.zips_adj_fd_ppg
                salary_counter += ofa.fd_salary
                ofs.each do |ofb|
                  roster << ofb.name
                  team_array << ofb.team.name
                  pts_counter += ofb.zips_adj_fd_ppg
                  salary_counter += ofb.fd_salary
                  ofs.each do |ofc|
                    roster << ofc.name
                    team_array << ofc.team.name
                    pts_counter += ofc.zips_adj_fd_ppg
                    salary_counter += ofc.fd_salary
                    pitchers.each do |p|
                      roster << p.name
                      team_array << p.team.name
                      pts_counter += p.zips_fd_pts_per_game
                      salary_counter += p.fd_salary
                      freq = team_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
                      modeteam = team_array.max_by { |v| freq[v] }
                      if salary_counter <= 35000 && pts_counter > high_score && roster.uniq.length == roster.length && freq[modeteam] < 5
                        high_score = pts_counter
                        team = roster.join(", ")
                        high_salary = salary_counter
                      end
                      roster.pop
                      team_array.pop
                      pts_counter -= p.zips_fd_pts_per_game
                      salary_counter -= p.fd_salary
                    end
                    roster.pop
                    team_array.pop
                    pts_counter -= ofc.zips_adj_fd_ppg
                    salary_counter -= ofc.fd_salary
                  end
                  roster.pop
                  team_array.pop
                  pts_counter -= ofb.zips_adj_fd_ppg
                  salary_counter -= ofb.fd_salary
                end
                roster.pop
                team_array.pop
                pts_counter -= ofa.zips_adj_fd_ppg
                salary_counter -= ofa.fd_salary
              end
              roster.pop
              team_array.pop
              pts_counter -= ss.zips_adj_fd_ppg
              salary_counter -= ss.fd_salary
            end
            roster.pop
            team_array.pop
            pts_counter -= t.zips_adj_fd_ppg
            salary_counter -= t.fd_salary
          end
          roster.pop
          team_array.pop
          pts_counter -= s.zips_adj_fd_ppg
          salary_counter -= s.fd_salary
        end
        roster.pop
        team_array.pop
        pts_counter -= f.zips_adj_fd_ppg
        salary_counter -= f.fd_salary
      end
      roster.pop
      team_array.pop
      pts_counter -= c.zips_adj_fd_ppg
      salary_counter -= c.fd_salary
    end
    team + " " + high_score.round(2).to_s + " $" + high_salary.to_s
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

  require 'csv'

  def self.import_zips_splits()
    CSV.foreach('zipssplits.csv') do |row|
      record = Batter.find_by name: row[0]
      unless record.blank?
        record.update_attributes(zips_pa_lhp: row[1], zips_ab_lhp: row[2], zips_hits_lhp: row[3], zips_doubles_lhp: row[4], zips_triples_lhp: row[5], zips_homers_lhp: row[6], zips_rbis_lhp: row[7], zips_walks_lhp: row[8], zips_hbps_lhp: row[10], zips_pa_rhp: row[18], zips_ab_rhp: row[19], zips_hits_rhp: row[20], zips_doubles_rhp: row[21], zips_triples_rhp: row[22], zips_homers_rhp: row[23], zips_rbis_rhp: row[24], zips_walks_rhp: row[25], zips_hbps_rhp: row[27] )
      end
    end
  end

end








