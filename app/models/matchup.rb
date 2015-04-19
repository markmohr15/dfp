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

class Matchup < ActiveRecord::Base

  belongs_to :visitor, class_name: "Team"
  belongs_to :home, class_name: "Team"

end
