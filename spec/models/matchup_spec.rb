# == Schema Information
#
# Table name: matchups
#
#  id         :integer          not null, primary key
#  visitor_id :integer
#  home_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_matchups_on_home_id     (home_id)
#  index_matchups_on_visitor_id  (visitor_id)
#

require 'rails_helper'

RSpec.describe Matchup, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
