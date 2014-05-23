require 'open-uri'

class RootController < ApplicationController
  def translate
    raise "Key unmatch" unless ENV['PRIVATE_TOKEN'] == params[:key]
    lines = TodoistIcalLoader.readlines ENV['TODOIST_EVENTS_URL'] || raise("Error")
    send_data lines.join("\n"), filename: 'icalTodoist.ics'
  end
end
