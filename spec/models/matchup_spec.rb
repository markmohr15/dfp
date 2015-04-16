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

require 'rails_helper'

RSpec.describe Matchup, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
