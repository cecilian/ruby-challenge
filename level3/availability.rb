require_relative 'date'
require_relative 'period'

class Availability
  def initialize developers, project, local_holidays
    @developers = developers
    @project = project
    @local_holidays = local_holidays
    @period = Period.new(id, date_since, date_until, @local_holidays)
  end

  def to_hash
    {
      "period_id": id,
      "total_days": @period.total_days,
      "workdays": @period.workdays,
      "weekend_days": @period.weekend_days,
      "holidays": @period.holidays,
      "feasibility": feasibility
    }
  end

  private

  def feasibility
    effort_days < developers_workdays
  end

  def effort_days
    @project["effort_days"]
  end

  def date_since
    @project["since"]
  end

  def date_until
    @project["until"]
  end

  def id
    @project["id"]
  end

  def developers_workdays
    @developers.inject(0) { |sum, d|  sum + @period.workdays_for(d) }
  end
end