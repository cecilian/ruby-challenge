require_relative 'date'

class Period
  attr_reader :id, :total_days, :workdays, :weekend_days, :holidays

  def initialize id, date_since, date_until, local_holidays
    @id = id
    @date_since = Date.parse(date_since)
    @date_until = Date.parse(date_until)
    @local_holidays = local_holidays.map { |holiday_hash| Date.parse(holiday_hash["day"]) }
    @total_days = 0
    @workdays = 0
    @weekend_days = 0
    @holidays = 0
    set_days_variables
  end

  def workdays_for developer
    developer_workdays = @workdays
    birthday = Date.parse(developer["birthday"]).change(year: 2017)
    developer_workdays += 1 if developer_has_day_off(birthday)
    developer_workdays
  end

  private

  def developer_has_day_off birthday
    in_range(birthday) && !(birthday.is_off_anyway? || @local_holidays.include?(birthday))
  end

  def in_range(birthday)
    (@date_since..@date_until).include? birthday
  end

  def set_days_variables
    (@date_since..@date_until).each do |day|
      @total_days += 1
      if day.weekend?
        @weekend_days += 1
      elsif day.holiday?(:it) || @local_holidays.include?(day)
        @holidays += 1
      end
    end
    @workdays = @total_days - @weekend_days - @holidays
  end
end