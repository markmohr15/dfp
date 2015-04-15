# == Schema Information
#
# Table name: pitchers
#
#  id            :integer          not null, primary key
#  name          :string
#  team          :string
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
#  starting      :boolean          default("false")
#

require 'rails_helper'

RSpec.describe Pitcher, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
