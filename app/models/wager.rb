# == Schema Information
#
# Table name: wagers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  matchup_id :integer
#  team_id    :integer
#  line       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_wagers_on_matchup_id  (matchup_id)
#  index_wagers_on_team_id     (team_id)
#  index_wagers_on_user_id     (user_id)
#

class Wager < ActiveRecord::Base

  belongs_to :user
  belongs_to :matchup
  belongs_to :team
end
