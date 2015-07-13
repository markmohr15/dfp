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
# Indexes
#
#  index_user_lines_on_matchup_id  (matchup_id)
#  index_user_lines_on_user_id     (user_id)
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
    self.line = self.matchup.line_calculation visitor_off, visitor_def, home_off, home_def
  end

end
