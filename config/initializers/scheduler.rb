require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.cron '59 0 * * *' do
  Team.get_stats
  Pitcher.get_stats 8
  Batter.get_stats 24
  Team.get_games (Date.today + 3.days).strftime("%Y-%m-%d")
end

