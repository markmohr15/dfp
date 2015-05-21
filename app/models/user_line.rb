# == Schema Information
#
# Table name: user_lines
#
#  id          :integer          not null, primary key
#  matchup_id  :integer
#  user_id     :integer
#  visitor_off :float
#  visitor_def :float
#  home_off    :float
#  home_def    :float
#  line        :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserLine < ActiveRecord::Base
  belongs_to :user
  belongs_to :matchup

  validates :user, presence: true
  validates :matchup, presence: true

  before_save :own_line, :destroy_prev

  def destroy_prev
    prev = UserLine.find_by(matchup_id: self.matchup_id, user_id: self.user_id)
    prev.destroy unless prev.nil?
  end

  def own_line
    return if visitor_off.blank?
    return if visitor_def.blank?
    return if home_off.blank?
    return if home_def.blank?
    visitor_offense = self.matchup.pf_adj visitor_off
    visitor_defense = self.matchup.pf_adj visitor_def
    home_offense = self.matchup.pf_adj home_off
    home_defense = self.matchup.pf_adj home_def
    visitor_exp = (visitor_offense + visitor_defense)**0.287
    home_exp = (home_offense + home_defense)**0.287
    visitor_pp = visitor_offense**visitor_exp / (visitor_offense**visitor_exp + visitor_defense**visitor_exp)
    home_pp = home_offense**home_exp / (home_offense**home_exp + home_defense**home_exp)
    visitor_log5 = (visitor_pp - home_pp * visitor_pp) / (visitor_pp + home_pp - 2 * visitor_pp * home_pp)
    home_log5 = (home_pp - visitor_pp * home_pp) / (home_pp + visitor_pp - 2 * home_pp * visitor_pp)
    visitor_hfa = visitor_log5 - 0.035
    home_hfa = home_log5 + 0.035
    self.line = (Matchup.decimal_to_moneyline home_hfa).round
  end

end
