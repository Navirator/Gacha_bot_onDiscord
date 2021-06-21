# frozen_string_literal: true

require 'pg'
require 'discordrb'
require 'date'
require 'dotenv/load'
require 'byebug'

class MyDefs
  def self.sizesql(db)
    size = db.exec('SELECT * FROM "Ships"')
    size.each do |row|
      size = row['ID']
    end
    size.to_i
  end

  def self.ship_name(id, db)
    db.exec('SELECT "ShipName" FROM "Ships" WHERE "ID"='+"#{id}")
  end

  def self.ship_day(id, db, day_ship)
    day = db.exec('SELECT "BirthdayDay" FROM "Ships" WHERE "ID"='+"#{id}")
    day.each do |row|
      day_ship = row['BirthdayDay']
    end
    day_ship.to_i
  end

  def self.month_ship(id, db, month_ship)
    month = db.exec('SELECT "BirthdayMonth" FROM "Ships" WHERE "ID"='+"#{id}")
    month.each do |row|
      month_ship = row['BirthdayMonth']
    end
    month_ship.to_i
  end

  def self.year_ship(id, db)
    db.exec('SELECT "BirthdayYear" FROM "Ships" WHERE "ID"='+"#{id}")
  end

  def self.search(db)
    today = Time.now
    this_day = today.day
    this_month = today.month
    i = 1
    a = 1
    while a <= 12
      while i <= sizesql(db)
        j = 1
        while j <= sizesql(db)
          ship_day = ship_day(j, db, nil)
          month_ship = month_ship(j, db, nil)
          if ship_day == this_day + 1 && month_ship == this_month
            ship = { 'day' => ship_day,
                     'month' => month_ship,
                     'id' => j }
            return ship
          else
            j += 1
          end
        end
        if this_day == 31
          this_day = 0
        else
          this_day += 1
        end
        i += 1
      end
      if this_month == 12
        this_month = 1
      else
        this_month += 1
      end
      a += 1
    end
  end
end
