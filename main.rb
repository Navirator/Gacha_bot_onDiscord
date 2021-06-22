# frozen_string_literal: true

require 'pg'
require 'discordrb'
require 'date'
require 'dotenv/load'
require 'byebug'
require './metods'
Dotenv.load unless ENV['RAILS_ENV'] == 'production'

db = PG.connect dbname: ENV['DBNAME'],
                user: ENV['USER'],
                host: ENV['HOST'],
                port: '5432',
                password: ENV['PASSWORD']

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
      mgs.respond 'Сегодня нет ни у кого дня рождения('
      ship = MyDefs.search(db)
      name = MyDefs.ship_name(ship['id'], db)
      year = MyDefs.year_ship(ship['id'], db)
      name.each do |row|
        mgs.respond "Ближайший день рождения у #{row['shipname']}."
      end
      year.each do |row|
        mgs.respond "#{ship['day']}/#{ship['month']}/#{row['birthdayyear']}"
      end
    end
    if day_ship == t.day && month_ship == t.month
      name.each do |row|
        mgs.respond "Сегодня день рождения y #{row['shipname']}."
      end

      year.each do |row|
        mgs.respond "#{t.day}/#{t.month}/#{row['birthdayyear']}"
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

