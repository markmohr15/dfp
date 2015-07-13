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
#  index_matchups_on_home_id              (home_id)
#  index_matchups_on_home_pitcher_id      (home_pitcher_id)
#  index_matchups_on_visiting_pitcher_id  (visiting_pitcher_id)
#  index_matchups_on_visitor_id           (visitor_id)
#

require 'rails_helper'

RSpec.describe Matchup, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
