# == Schema Information
#
# Table name: pitchers
#
#  id             :integer          not null, primary key
#  name           :string
#  zips_wins      :integer
#  zips_games     :integer
#  zips_gs        :integer
#  zips_ip        :integer
#  zips_er        :integer
#  zips_so        :integer
#  zips_whip      :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  fd_salary      :integer
#  fd_season_ppg  :float
#  reliever       :boolean          default("false")
#  zips_homers    :integer
#  zips_hits      :integer
#  team_id        :integer
#  selected       :boolean
#  sierra         :float
#  steamer_wins   :integer
#  steamer_games  :integer
#  steamer_gs     :integer
#  steamer_ip     :integer
#  steamer_er     :integer
#  steamer_so     :integer
#  steamer_whip   :integer
#  steamer_homers :integer
#  steamer_hits   :integer
#  throws         :integer
#  fip            :float
#  xfip           :float
#
# Indexes
#
#  index_pitchers_on_team_id  (team_id)
#

require 'rails_helper'

RSpec.describe Pitcher, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
