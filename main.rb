# frozen_string_literal: true

require 'sqlite3'
require 'discordrb'
require 'date'
require 'dotenv/load'
require 'byebug'
require './metods'

db = SQLite3::Database.open 'db/Ships_test.db'
db.results_as_hash = true

bot = Discordrb::Commands::CommandBot.new(token: ENV['TOKEN'],
                                          client_id: ENV['CLIENT_ID'],
                                          prefix: ENV['PREFIX'])
bot.command :день_рождения do |mgs|
  t = Time.now
  i = 1
  check = 1
  while i <= MyDefs.sizesql(db)
    day_ship = nil
    month_ship = nil

    day_ship = MyDefs.ship_day(i, db, day_ship)

    month_ship = MyDefs.month_ship(i, db, month_ship)

    name = MyDefs.ship_name(i, db)

    year = MyDefs.year_ship(i, db)

    if check == MyDefs.sizesql(db)
      mgs.respond 'Сегодня нет ни у кого день рождения('
      ship = MyDefs.search(db)
      name = MyDefs.ship_name(ship['id'], db)
      year = MyDefs.year_ship(ship['id'], db)
      name.each do |row|
        mgs.respond "Ближайший день рождения у #{row['ShipName']}."
      end
      year.each do |row|
        mgs.respond "#{ship['day']}/#{ship['month']}/#{row['BirthdayYear']}"
      end
    end
    if day_ship == t.day && month_ship == t.month
      name.each do |row|
        mgs.respond "Сегодня день рождения y #{row['ShipName']}."
      end

      year.each do |row|
        mgs.respond "#{t.day}/#{t.month}/#{row['BirthdayYear']}"
      end
    else
      check += 1
    end
    i += 1
  end
end

bot.command :спать do |mgs|
  mgs.respond 'Ложусь спать...'
  mgs.respond 'Zzzz'
  bot.stop
end

at_exit { bot.stop }
bot.run
