require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '24h' do
  Team.get_stats
  Pitcher.get_stats 7
  Batter.get_games (Date.today + 3.days).strftime("%Y-%m-%d")
end

