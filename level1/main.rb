require "json"
require "date"
require "holidays"

class Tractus
  def self.generate_output filename
    periods = read_input filename
    availabilities = periods.map { |p| Availability.new(p) }
    { "availabilities": availabilities.map(&:to_hash) }.to_json
  end

  private

  def self.read_input filename
    availabilities = []
    file = File.read(filename)
    periods = JSON.parse(file)["periods"]
  end

  class Availability
    def initialize period
      @period_id = period["id"]
      @date_since = Date.parse(period["since"])
      @date_until = Date.parse(period["until"])
      @total_days = 0
      @workdays = 0
      @holidays = 0
      @weekend_days = 0
      set_days_variables
    end

    def to_hash
      {
        "period_id": @period_id,
        "total_days": @total_days,
        "workdays": @workdays,
        "weekend_days": @weekend_days,
        "holidays": @holidays
      }
    end

    private

    def set_days_variables
      (@date_since..@date_until).each do |day|
        @total_days += 1
        if is_weekend?(day)
          @weekend_days += 1
        elsif is_holiday?(day)
          @holidays += 1
        end
      end
      @workdays = @total_days - @weekend_days - @holidays
    end

    def is_holiday? day
      Holidays.on(day, :it).any?
    end

    def is_weekend? day
      day.saturday? || day.sunday?
    end
  end
end
