require 'open-uri'

class Converter
  attr_accessor :lines, :state, :start_date, :start_time, :period
  def initialize(lines)
    @lines = lines
    @state = nil
  end
  def self.convert_lines(lines)
    new(lines).convert_lines
  end
  def convert_lines
    output_lines = []
    @state = :none
    lines.each do |line|
      case @state
      when :none
        line = process_none line
      when :vevent
        line = process_vevent line
      when :vdate
        line = process_vdate line
      when :vtime
        line = process_vtime line
      end
      output_lines << line
    end
    output_lines
  end
  def process_none(line)
    if line == 'BEGIN:VEVENT'
      @state = :vevent
    end
    line
  end
  def process_vevent(line)
    case line
    when 'END:VEVENT'
      # reset saved values.
      @period = @start_date = @start_time = nil
      @state = :none
    when /^SUMMARY:(.+)$/
      @period = detect_period $1
      # SUMMARY:繰り返しのイベント (10:00-12:00)
    when /^DTSTART;VALUE=DATE:(\d{8})$/
      # 20140602
      # type: date
      # pickup start date
      @start_date = Date.parse($1)
      @state = :vdate
    when /^DTSTART;TZID="GMT \+09:00";VALUE=DATE-TIME:(\d{8}T\d{6})$/
      # 20140602T110000
      # type: time
      # pickup start time
      @start_time = Time.parse($1)
      @state = :vtime
    end
    line
  end
  def process_vdate(line)
    case line
    when /^(DTEND;VALUE=DATE:)\d{8}$/
      header = $1
      @state = :vevent
      if period
        line = make_line(header: header, start_date: start_date, period: period) || line
      end
    end
    line
  end
  def process_vtime(line)
    case line
    when /^(DTEND;TZID="GMT \+09:00";VALUE=DATE-TIME:)\d{8}T\d{6}$/
      @state = :vevent
      if period
        line = make_line(header: $1, start_time: start_time, period: period) || line
      end
    end
    line
  end
  def detect_period(string)
    # - 10:00 time
    return {hour: $1, min: $2} if string =~ /\b-\s*([012]?\d)\s*:\s*([0-5]?\d)/
    # - 5/10 9:00 date/time
    return {month: $1, day: $2, hour: $3, min: $4} if string =~ /\b-\s*([01]?\d)\/([0123]?\d)\s+([012]?\d)\s*:\s*([0-5]?\d)/
    # - 2014/3/1 15:00 date-full/time
    return { year: $1, month: $2, day: $3, hour: $4, min: $5 } if string =~ /\b-\s*(\d\d\d\d)\/([01]?\d)\/([0123]?\d)\s+([012]?\d)\s*:\s*([0-5]?\d)/
    # - 10/2 date
    return { month: $1, day: $2 } if string =~ /\b-\s*([01]?\d)\/([0123]?\d)/
    # - 2014/5/2 date
    return { year: $1, month: $2, day: $3 } if string =~ /\b-\s*(\d{4})\/([01]?\d)\/([0123]?\d)/
    # - \d+ day(s)
    return { num_days: $1 } if string =~ /[\-\(]\s*(\d+)\s*days?\b/
    # - \d+ 日間
    return { num_days: $1 } if string =~ /[\-\(]\s*(\d+)\s*日間?\b/
    # - \d hour(s)
    return { num_hours: $1 } if string =~ /[\-\(]\s*(\d+)\s*hours?\b/
    # - \d mins
    return { num_mins: $1 }  if string =~ /[\-\(]\s*(\d+)\s*min(ute)?s?\b/
    nil
  end
  def make_line(params)
    if params[:start_date]
      make_line_date params
    elsif params[:start_time]
      make_line_time params
    else raise "Unexpected params:#{params}"
    end
  end
  def make_line_date(params)
    period = params[:period]
    start_date = params[:start_date]
    if period[:num_days]
      end_date = start_date + period[:num_days].to_i.days
      "#{params[:header]}#{end_date.strftime('%Y%m%d')}"
    elsif period[:month] && period[:day] && !period[:hour] # seems to be date.
      y = period[:year] ||= Date.today.year.to_s
      end_date = Date.parse("#{y}/#{period[:month]}/#{period[:day]}")
      "#{params[:header]}#{end_date.strftime('%Y%m%d')}"
    else
      nil
    end
  end
  def make_line_time(params)
    period = params[:period]
    start_time = params[:start_time]
    if period[:num_hours]
      end_time = start_time + period[:num_hours].to_i.hours
      "#{params[:header]}#{end_time.strftime('%Y%m%dT%H%M%S')}"
    elsif period[:hour] && period[:min]
      year = period[:year] || start_time.year
      month = period[:month] || start_time.month
      day = period[:day] || start_time.day
      end_time = Time.local(year.to_i, month.to_i, day.to_i,
                            period[:hour].to_i, period[:min].to_i, 0)
      "#{params[:header]}#{end_time.strftime('%Y%m%dT%H%M%S')}"
    elsif period[:num_hours]
      end_time = start_time + period[:num_hours].to_i.hours
      "#{params[:header]}#{end_time.strftime('%Y%m%dT%H%M%S')}"
    elsif period[:num_mins]
      end_time = start_time + period[:num_mins].to_i.minutes
      "#{params[:header]}#{end_time.strftime('%Y%m%dT%H%M%S')}"
    else
      nil
    end
  end
end
