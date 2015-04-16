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

class Matchup < ActiveRecord::Base

  belongs_to :visitor, class_name: "Team"
  belongs_to :home, class_name: "Team"

end
