require 'json'
require_relative 'availability'

class Tractus
  def initialize filename
    json = JSON.parse(File.read(filename))
    @developers = json["developers"]
    @projects = json["projects"]
    @local_holidays = json["local_holidays"]
  end

  def to_json
    { "availabilities": availabilities.map(&:to_hash) }.to_json
  end

  private

  def availabilities
    availabilities = [] 
    @projects.map { |p| availabilities << Availability.new(@developers, p, @local_holidays) }
    availabilities
  end
end
