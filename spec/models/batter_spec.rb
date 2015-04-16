# == Schema Information
#
# Table name: batters
#
#  id            :integer          not null, primary key
#  name          :string
#  position      :text
#  pa            :integer
#  ab            :integer
#  hits          :integer
#  doubles       :integer
#  triples       :integer
#  homers        :integer
#  runs          :integer
#  rbis          :integer
#  walks         :integer
#  hbps          :integer
#  sb            :integer
#  cs            :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fd_salary     :integer
#  fd_season_ppg :float
#  pitcher_id    :integer
#  team_id       :integer
#

require 'rails_helper'

RSpec.describe Batter, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
