require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.cron '55 5 * * *' do
  Team.get_stats
  Pitcher.get_stats 25
  Batter.get_stats 25
  Team.get_games (Date.today + 3.days).strftime("%Y-%m-%d")
  Matchup.get_close
end


