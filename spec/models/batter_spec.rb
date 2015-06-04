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
#  zips_pa_rhp              :integer
#  zips_ab_rhp              :integer
#  zips_hits_rhp            :integer
#  zips_doubles_rhp         :integer
#  zips_triples_rhp         :integer
#  zips_homers_rhp          :integer
#  zips_runs_rhp            :integer
#  zips_rbis_rhp            :integer
#  zips_walks_rhp           :integer
#  zips_hbps_rhp            :integer
#  zips_pa_lhp              :integer
#  zips_ab_lhp              :integer
#  zips_hits_lhp            :integer
#  zips_doubles_lhp         :integer
#  zips_triples_lhp         :integer
#  zips_homers_lhp          :integer
#  zips_runs_lhp            :integer
#  zips_rbis_lhp            :integer
#  zips_walks_lhp           :integer
#  zips_hbps_lhp            :integer
#  pa_rhp                   :integer
#  ab_rhp                   :integer
#  hits_rhp                 :integer
#  doubles_rhp              :integer
#  triples_rhp              :integer
#  homers_rhp               :integer
#  runs_rhp                 :integer
#  rbis_rhp                 :integer
#  walks_rhp                :integer
#  hbps_rhp                 :integer
#  pa_lhp                   :integer
#  ab_lhp                   :integer
#  hits_lhp                 :integer
#  doubles_lhp              :integer
#  triples_lhp              :integer
#  homers_lhp               :integer
#  runs_lhp                 :integer
#  rbis_lhp                 :integer
#  walks_lhp                :integer
#  hbps_lhp                 :integer
#  pa                       :integer
#  ab                       :integer
#  hits                     :integer
#  doubles                  :integer
#  triples                  :integer
#  homers                   :integer
#  runs                     :integer
#  rbis                     :integer
#  walks                    :integer
#  hbps                     :integer
#  sb                       :integer
#  cs                       :integer
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
