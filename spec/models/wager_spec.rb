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

require 'rails_helper'

RSpec.describe Wager, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
