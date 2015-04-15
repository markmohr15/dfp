# == Schema Information
#
# Table name: pitchers
#
#  id         :integer          not null, primary key
#  name       :string
#  team       :string
#  wins       :integer
#  games      :integer
#  gs         :integer
#  ip         :integer
#  er         :integer
#  so         :integer
#  whip       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fd_salary  :integer
#

class Pitcher < ActiveRecord::Base

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def fd_pts_per_game
    season_pts = self.wins * 4 + self.er * -1 + self.so * 1 + self.ip * 1
    season_pts / self.games.to_f
  end

  def fd_pts_per_1000_dollars
    if self.fd_salary.blank?
      "N/A"
    else
      sprintf('%.2f', self.fd_pts_per_game / self.fd_salary * 1000)
    end
  end

  def self.sorted_by_fd_pts_per_1000_dollars
    Pitcher.where("fd_salary > 0").sort_by(&:fd_pts_per_1000_dollars).reverse!
  end

end
