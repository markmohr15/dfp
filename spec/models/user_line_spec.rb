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

require 'rails_helper'

RSpec.describe UserLine, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
