# == Schema Information
#
# Table name: matchups
#
#  id                  :integer          not null, primary key
#  visitor_id          :integer
#  home_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  visiting_pitcher_id :integer
#  home_pitcher_id     :integer
#  day                 :date
#  pin_vis_close       :integer
#  pin_home_close      :integer
#
# Indexes
#
#  index_matchups_on_home_id     (home_id)
#  index_matchups_on_visitor_id  (visitor_id)
#

class Matchup < ActiveRecord::Base

  belongs_to :visitor, class_name: "Team"
  belongs_to :home, class_name: "Team"
  belongs_to :visiting_pitcher, class_name: "Pitcher"
  belongs_to :home_pitcher, class_name: "Pitcher"

  def zips_tl_line
    visitor_off = self.pf_adj(self.visitor.zips_true_lineup_offense(self.home_pitcher.name))
    visitor_def = self.pf_adj(self.visitor.zips_defense(self.visiting_pitcher.name))
    home_off = self.pf_adj(self.home.zips_true_lineup_offense(self.visiting_pitcher.name))
    home_def = self.pf_adj(self.home.zips_defense(self.home_pitcher.name))
    self.line_calculation visitor_off, visitor_def, home_off, home_def
  end

  def zips_ov_line
    visitor_off = self.pf_adj(self.visitor.zips_overnight_offense(self.home_pitcher.name))
    visitor_def = self.pf_adj(self.visitor.zips_defense(self.visiting_pitcher.name))
    home_off = self.pf_adj(self.home.zips_overnight_offense(self.visiting_pitcher.name))
    home_def = self.pf_adj(self.home.zips_defense(self.home_pitcher.name))
    self.line_calculation visitor_off, visitor_def, home_off, home_def
  end

  def steamer_tl_line
    visitor_off = self.pf_adj self.visitor.zips_true_lineup_offense
    visitor_def = self.pf_adj(self.visitor.steamer_defense(self.visiting_pitcher.name))
    home_off = self.pf_adj self.home.zips_true_lineup_offense
    home_def = self.pf_adj(self.home.steamer_defense(self.home_pitcher.name))
    self.line_calculation visitor_off, visitor_def, home_off, home_def
  end

  def line_calculation vis_offense, vis_defense, home_offense, home_defense
    visitor_off = self.pf_adj vis_offense
    visitor_def = self.pf_adj vis_defense
    home_off = self.pf_adj home_offense
    home_def = self.pf_adj home_defense
    visitor_exp = (visitor_off + visitor_def)**0.287
    home_exp = (home_off + home_def)**0.287
    visitor_pp = visitor_off**visitor_exp / (visitor_off**visitor_exp + visitor_def**visitor_exp)
    home_pp = home_off**home_exp / (home_off**home_exp + home_def**home_exp)
    visitor_log5 = (visitor_pp - home_pp * visitor_pp) / (visitor_pp + home_pp - 2 * visitor_pp * home_pp)
    home_log5 = (home_pp - visitor_pp * home_pp) / (home_pp + visitor_pp - 2 * home_pp * visitor_pp)
    visitor_hfa = visitor_log5 - 0.035
    home_hfa = home_log5 + 0.035
    (Matchup.decimal_to_moneyline home_hfa).round
  end

  def pf_adj n
    if n.blank?
      100
    else
      (n * self.home.park_factor).round(2)
    end
  end

  def self.decimal_to_moneyline decimal
    if decimal > 0.50
      (-100 / ( 1 / decimal - 1)).round
    else
      ((1 / decimal - 1) * 100).round
    end
  end

  def user_line_visitor_off user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    if user_line.blank?
      old_lines = UserLine.joins(:matchup).where('user_id' => user.id, 'matchups.visitor_id' => self.visitor_id)
      old_lines += UserLine.joins(:matchup).where('user_id' => user.id, 'matchups.home_id' => self.visitor_id)
      return if old_lines.blank?
      old_lines.sort! { |a,b| a.matchup_id <=> b.matchup_id }
      if old_lines.last.matchup.visitor == self.visitor
        old_lines.last.visitor_off
      else
        old_lines.last.home_off
      end
    else
      user_line.visitor_off
    end
  end

  def user_line_visitor_def user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    if user_line.blank?
      old_matchups = Matchup.where("visiting_pitcher_id = ? or home_pitcher_id = ?", self.visiting_pitcher_id, self.visiting_pitcher_id)
      return if old_matchups.count == 1
      old_line = UserLine.find_by(matchup_id: old_matchups[-2].id, user_id: user.id)
      return if old_line.blank?
      if old_matchups[-2].visiting_pitcher == self.visiting_pitcher
        old_line.visitor_def
      else
        old_line.home_def
      end
    else
      user_line.visitor_def
    end
  end

  def user_line_home_off user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    if user_line.blank?
      old_lines = UserLine.joins(:matchup).where('user_id' => user.id, 'matchups.visitor_id' => self.home_id)
      old_lines += UserLine.joins(:matchup).where('user_id' => user.id, 'matchups.home_id' => self.home_id)
      return if old_lines.blank?
      old_lines.sort! { |a,b| a.matchup_id <=> b.matchup_id }
      if old_lines.last.matchup.visitor == self.home
        old_lines.last.visitor_off
      else
        old_lines.last.home_off
      end
    else
      user_line.home_off
    end
  end

  def user_line_home_def user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    if user_line.blank?
      old_matchups = Matchup.where("visiting_pitcher_id = ? or home_pitcher_id = ?", self.home_pitcher_id, self.home_pitcher_id)
      return if old_matchups.count == 1
      old_line = UserLine.find_by(matchup_id: old_matchups[-2].id, user_id: user.id)
      return if old_line.blank?
      if old_matchups[-2].visiting_pitcher == self.home_pitcher
        old_line.visitor_def
      else
        old_line.home_def
      end
    else
      user_line.home_def
    end
  end

  def my_line user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    return if user_line.blank?
    return if user_line.line.blank?
    user_line.line.round
  end

  def self.get_close
    agent = Mechanize.new
    stuff = agent.get("http://www.sportsbookreview.com/betting-odds/mlb-baseball/").search(".status-complete")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    data.each do |x|
      team = Team.find_by(alias: x[7][0].split('-').first[0..-2]).id
      matchup = Matchup.find_by(visitor_id: team, day: Date.today - 1.day)#, pin_vis_close: nil)
      unless matchup.blank?
        matchup.pin_vis_close = x[11][0][0..3].to_i
        matchup.pin_home_close = x[11][0][4..7].to_i
        matchup.save
      end
    end
  end

  def no_vig_close
    return if self.pin_vis_close.blank?
    overround = 0
    if self.pin_vis_close < 0
      overround += self.pin_vis_close * -1.0 / (self.pin_vis_close * -1.0 + 100)
    else
      overround += 100.0 / (self.pin_vis_close + 100)
    end
    if self.pin_home_close < 0
      home_odds = self.pin_home_close * -1.0 / (self.pin_home_close * -1.0 + 100)
      overround += home_odds
    else
      home_odds = 100.0 / (self.pin_home_close + 100)
      overround += home_odds
    end
    home_win_pct = home_odds / overround
    if home_win_pct > 0.5
      (home_win_pct / (1 - home_win_pct) * -100).round
    else
      ((1 - home_win_pct) / home_win_pct * 100).round
    end
  end

  def self.get_pitchers date # format 2015/06/16
    agent = Mechanize.new
    stuff = agent.get("http://mlb.mlb.com/news/probable_pitchers/?c_id=mlb&date=" + date).search(".module")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    data.each do |x|
      name = x[0][0].split("@")[0][0..-2].split(" ").last
      if name == "Sox" || name == "Jays"
        name = x[0][0].split("@")[0][0..-2].split(" ").second
      end
      team = Team.where("name ilike '%#{name}%'").first
      matchup = Matchup.find_by(visitor_id: team.id, day: date)
      unless x[2][0].split(",")[0] == "To Be Announced"
        matchup.visiting_pitcher = Pitcher.where(name: x[2][0].split(",")[0]).first_or_create
      end
      unless x[3][0].split(",")[0] == "To Be Announced"
        matchup.home_pitcher = Pitcher.where(name: x[3][0].split(",")[0]).first_or_create
      end
      matchup.save
    end
  end

end
