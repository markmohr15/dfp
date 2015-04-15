# == Schema Information
#
# Table name: batters
#
#  id         :integer          not null, primary key
#  name       :string
#  team       :string
#  position   :text
#  pa         :integer
#  ab         :integer
#  hits       :integer
#  doubles    :integer
#  triples    :integer
#  homers     :integer
#  runs       :integer
#  rbis       :integer
#  walks      :integer
#  hbps       :integer
#  sb         :integer
#  cs         :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fd_salary  :integer
#

class Batter < ActiveRecord::Base

  def display_fd_salary
    if self.fd_salary.blank?
      "N/A"
    else
      self.fd_salary
    end
  end

  def fd_pts_per_game
    season_pts = self.hits * 1 + self.doubles * 1 + self.triples * 2 + self.homers * 3 + self.rbis * 1 +
     self.runs * 1 + self.walks * 1 + self.sb * 2 + self.hbps * 1 + (ab - hits) * -0.25
    season_pts / pa * 4.25
  end

  def fd_pts_per_1000_dollars
    if self.fd_salary.blank?
      "N/A"
    else
      sprintf('%.2f', self.fd_pts_per_game / self.fd_salary * 1000)
    end
  end

  def self.sorted_by_fd_pts_per_1000_dollars
    Batter.where("fd_salary > 0").sort_by(&:fd_pts_per_1000_dollars).reverse!
  end

  def self.get_fd_data url
    agent = Mechanize.new
    stuff = agent.get(url).search(".pR")
    data = stuff.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.compact
    data.each do |x|
      if x[0].join(",") == "P"
        p = Pitcher.find_by(name: x[1].join(","))
        unless p.nil?
          p.update_attributes(fd_salary: (x[5].join(","))[1..-1].gsub(",", "").to_i)
        end
      else
        b = Batter.find_by(name: x[1].join(","))
        unless b.nil?
          b.update_attributes(fd_salary: (x[5].join(","))[1..-1].gsub(",", "").to_i)
        end
      end
    end
  end





end
