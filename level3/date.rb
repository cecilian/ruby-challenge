require 'date'
require 'holidays'
require 'holidays/core_extensions/date'

class Date
  include Holidays::CoreExtensions::Date

  def is_birthday? developer
    birthday = Date.parse(developer["birthday"])
    day == birthday.day && month == birthday.month
  end

  def weekend?
    saturday? || sunday?
  end

  def is_off_anyway?
    weekend? || holiday?(:it)
  end 
end