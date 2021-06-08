require 'sqlite3'
require 'discordrb'
require 'date'
require 'dotenv/load'
require 'byebug'


db = SQLite3::Database.open "db/Ships_test.db"
db.results_as_hash = true

t = Time.now
i = 1
f = 1

bot = Discordrb::Commands::CommandBot.new(token: ENV['TOKEN'],
                                          client_id: ENV['CLIENT_ID'],
                                          prefix: ENV['PREFIX'])
bot.command :день_рождения do |mgs|
  while i <= 250
    d = nil
    m = nil

    if f == 250
      mgs.respond "Сегодня нет ни у кого день рождения("
    end

    name = db.execute <<-SQL
       SELECT ShipName FROM Ships WHERE ID==#{i}
    SQL

    day = db.execute <<-SQL
       SELECT BirthdayDay FROM Ships WHERE ID==#{i}
    SQL

    day.each do |row|
      d = row['BirthdayDay']
    end

    month = db.execute <<-SQL
       SELECT BirthdayMonth FROM Ships WHERE ID==#{i}
    SQL

    month.each do |row|
      m = row['BirthdayMonth']
    end

    year = db.execute <<-SQL
       SELECT BirthdayYear FROM Ships WHERE ID==#{i}
    SQL

    if d == t.day && m == t.month
      name.each do |row|
        mgs.respond "Сегодня день рождения y #{row['ShipName']}"
      end

      year.each do |row|
        mgs.respond "#{t.day.to_s}/#{t.month.to_s}/#{row['BirthdayYear']}"
      end
    else
      f +=1
    end
    i += 1
  end
end

at_exit { bot.stop }
bot.run
