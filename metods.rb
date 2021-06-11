require 'sqlite3'
require 'discordrb'
require 'date'
require 'dotenv/load'
require 'byebug'

class MyDefs
  def self.sizesql(db)
    size = db.execute <<-SQL
         SELECT COUNT(*) FROM Ships
    SQL
    size.each do |row|
      size = row['COUNT(*)']
    end
    return size
  end

  def self.ship_name(i, db)
    name = db.execute <<-SQL
         SELECT ShipName FROM Ships WHERE ID==#{i}
    SQL
    return name
  end

  def self.ship_day(i, db, day_ship)
    day = db.execute <<-SQL
         SELECT BirthdayDay FROM Ships WHERE ID==#{i}
    SQL
    day.each do |row|
      day_ship = row['BirthdayDay']
    end
    return day_ship
  end

  def self.month_ship(i, db, month_ship)
    month = db.execute <<-SQL
         SELECT BirthdayMonth FROM Ships WHERE ID==#{i}
    SQL
    month.each do |row|
      month_ship = row['BirthdayMonth']
    end
    return month_ship
  end

  def self.year_ship(i, db)
    year = db.execute <<-SQL
         SELECT BirthdayYear FROM Ships WHERE ID==#{i}
    SQL
    return year
  end

  def self.search(j, db)
    today = Time.now
    this_day = today.day
    this_month = today.month
    i = j
    a = 1
    while a <= 12
      while i <= sizesql(db)
        month = month_ship(i, db, nil)
        while j <= sizesql(db)
          day = ship_day(j, db, nil)
          if day == this_day && month == this_month

            array = "aaa"
            return array
          else
            j += 1
            array = "bbb"
            return array
          end
        end
        this_day += 1
        i += 1
      end
      this_month += 1
      if a == 1
        a = 1
      else
        a += 1
      end
    end
  end
end
