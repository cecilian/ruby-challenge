require 'json'
require 'date'
require 'holidays'
require 'holidays/core_extensions/date'
require 'pry'

class Tractus
  def initialize filename
    json = JSON.parse(File.read(filename))
    @developers = json["developers"]
    @periods = json["periods"]
    @local_holidays = json["local_holidays"]
  end

  def to_json
    { "availabilities": availabilities.map(&:to_hash) }.to_json
  end

  private

  def availabilities
    availabilities = []
    @developers.each do |d| 
      @periods.each do |p| 
        availabilities << Availability.new(d, p, @local_holidays)
      end
    end
    availabilities
  end

  class Availability
    def initialize developer, period, local_holidays
      @developer = developer
      @period = period
      @local_holidays = local_holidays.map { |holiday_hash| Date.parse(holiday_hash["day"]) }
      @total_days = 0
      @workdays = 0
      @weekend_days = 0
      @holidays = 0
      set_days_variables
    end

    def to_hash
      {
        "developer_id": @developer["id"],
        "period_id": @period["id"],
        "total_days": @total_days,
        "workdays": @workdays,
        "weekend_days": @weekend_days,
        "holidays": @holidays
      }
    end

    private

    def set_days_variables
      (date_since..date_until).each do |day|
        @total_days += 1
        if day.weekend?
          @weekend_days += 1
        elsif day.holiday?(:it) || @local_holidays.include?(day) || day.is_birthday?(@developer)
          @holidays += 1
        end
      end
      @workdays = @total_days - @weekend_days - @holidays
    end

    def date_since
      Date.parse(@period["since"])
    end

    def date_until
      Date.parse(@period["until"])
    end
  end
end

class Date
  include Holidays::CoreExtensions::Date

  def is_birthday? developer
    birthday = Date.parse(developer["birthday"])
    day == birthday.day && month == birthday.month
  end

  def weekend?
    saturday? || sunday?
  end     
end
