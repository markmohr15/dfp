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
    visitor_off = self.pf_adj self.visitor.zips_true_lineup_offense
    visitor_def = self.pf_adj(self.visitor.zips_defense(self.visiting_pitcher.name))
    home_off = self.pf_adj self.home.zips_true_lineup_offense
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
    (n * self.home.park_factor).round(2)
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
    return if user_line.blank?
    user_line.visitor_off
  end

  def user_line_visitor_def user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    return if user_line.blank?
    user_line.visitor_def
  end

  def user_line_home_off user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    return if user_line.blank?
    user_line.home_off
  end

  def user_line_home_def user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    return if user_line.blank?
    user_line.home_def
  end

  def my_line user
    user_line = UserLine.find_by(user_id: user.id, matchup_id: self.id)
    return if user_line.blank?
    return if user_line.line.blank?
    user_line.line.round
  end


end
