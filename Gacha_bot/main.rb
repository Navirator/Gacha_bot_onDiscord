require 'sqlite3'
require 'discordrb'
require 'date'

config = File.foreach('config.txt').map { |line| line.split(' ').join(' ') }
bot = Discordrb::Commands::CommandBot.new token: "#{config[0].to_s}",
                                          client_id: "#{config[1].to_s}",
                                          prefix: "#{config[2].to_s}"
db = SQLite3::Database.open "Ships_test.db"
db.results_as_hash = true

t = Time.now
i = 1
f = 1
bot.command :день_рождения do |mgs|
  while i <= 3
    #d = db.query "SELECT BirthdayDay FROM 'Ships' WHERE ID==1"
    #m = db.query "SELECT BirthdayMonth FROM 'Ships' WHERE ID==1"

    if f == 250
      mgs.respond "Сегодня нет ни у кого день рождения("
    end

    #if d == t.day && m == t.month
      name = db.query "SELECT ShipName FROM 'Ships' WHERE ID==1"
      mgs.respond "Сегодня день рождения #{t.day.to_s}/#{t.month.to_s} y #{name}"
    #else
    #  f +=1
    #end
    i += 1
  end
end

at_exit { bot.stop }
bot.run
