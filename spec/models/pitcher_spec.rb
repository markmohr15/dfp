# == Schema Information
#
# Table name: pitchers
#
#  id            :integer          not null, primary key
#  name          :string
#  wins          :integer
#  games         :integer
#  gs            :integer
#  ip            :integer
#  er            :integer
#  so            :integer
#  whip          :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fd_salary     :integer
#  fd_season_ppg :float
#  reliever      :boolean          default("false")
#  homers        :integer
#  hits          :integer
#  team_id       :integer
#  selected      :boolean
#
# Indexes
#
#  index_pitchers_on_team_id  (team_id)
#

require 'rails_helper'

RSpec.describe Pitcher, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
