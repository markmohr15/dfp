# == Schema Information
#
# Table name: batters
#
#  id                       :integer          not null, primary key
#  name                     :string
#  position                 :text
#  zips_pa                  :integer
#  zips_ab                  :integer
#  zips_hits                :integer
#  zips_doubles             :integer
#  zips_triples             :integer
#  zips_homers              :integer
#  zips_runs                :integer
#  zips_rbis                :integer
#  zips_walks               :integer
#  zips_hbps                :integer
#  zips_sb                  :integer
#  zips_cs                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  fd_salary                :integer
#  fd_season_ppg            :float
#  pitcher_id               :integer
#  team_id                  :integer
#  zips_adj_fd_ppg          :float
#  lineup_spot              :integer
#  selected                 :boolean
#  rh_overnight_lineup_spot :integer
#  lh_overnight_lineup_spot :integer
#
# Indexes
#
#  index_batters_on_pitcher_id  (pitcher_id)
#  index_batters_on_team_id     (team_id)
#

require 'rails_helper'

RSpec.describe Batter, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
