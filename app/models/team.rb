# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ActiveRecord::Base

  has_many :matchups_as_visitor, class_name: "Matchup", foreign_key: "visitor_id"
  has_many :matchups_as_home, class_name: "Matchup", foreign_key: "home_id"
  has_many :batters
  has_many :pitchers

end
