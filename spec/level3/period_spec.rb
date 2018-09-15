require 'json'
require_relative '../../level3/period.rb'

describe 'Period' do
  subject { Period.new(1, "2017-01-01", "2017-12-31", [JSON.parse("{ \"day\": \"2017-06-13\", \"name\": \"Santo Patrono di Padova\" }")]) }

  it 'sets the workdays,weekend and holidays correctly' do
    expect(subject.total_days).to eq 365
    expect(subject.workdays).to eq 249
    expect(subject.weekend_days).to eq 105
    expect(subject.holidays).to eq 11
  end
end