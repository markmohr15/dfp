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

  def line
    visitor_off = self.pf_adj self.visitor.true_lineup_offense
    visitor_def = self.pf_adj(self.visitor.defense(self.visiting_pitcher.name))
    home_off = self.pf_adj self.home.true_lineup_offense
    home_def = self.pf_adj(self.home.defense(self.home_pitcher.name))
    visitor_exp = (visitor_off + visitor_def)**0.287
    home_exp = (home_off + home_def)**0.287
    visitor_pp = visitor_off**visitor_exp / (visitor_off**visitor_exp + visitor_def**visitor_exp)
    home_pp = home_off**home_exp / (home_off**home_exp + home_def**home_exp)
    visitor_log5 = (visitor_pp - home_pp * visitor_pp) / (visitor_pp + home_pp - 2 * visitor_pp * home_pp)
    home_log5 = (home_pp - visitor_pp * home_pp) / (home_pp + visitor_pp - 2 * home_pp * visitor_pp)
    visitor_hfa = visitor_log5 - 0.035
    home_hfa = home_log5 + 0.035
    home_hfa
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

end
