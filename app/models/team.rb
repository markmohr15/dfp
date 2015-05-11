# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  park_factor :float
#

class Team < ActiveRecord::Base

  has_many :matchups_as_visitor, class_name: "Matchup", foreign_key: "visitor_id"
  has_many :matchups_as_home, class_name: "Matchup", foreign_key: "home_id"
  has_many :batters
  has_many :pitchers

  accepts_nested_attributes_for :batters

  def fd_ppg
    lineup = Batter.where("team_id = ? and lineup_spot > ?", self.id, 0)
    pts_counter = 0
    lineup.each do |x|
      pts_counter += x.fd_pts_per_game
    end
    pts_counter
  end

  def home?
    game = Matchup.find_by("visitor_id in (?) or home_id in (?)", self.id, self.id)
    return if game.nil?
    if game.visitor_id == self.id
      false
    else
      true
    end
  end

end
