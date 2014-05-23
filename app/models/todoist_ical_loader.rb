require 'open-uri'

class TodoistIcalLoader
  def self.readlines(url_or_file)
    Converter.convert_lines open(url_or_file).read.split(/\n/)
  end
end
