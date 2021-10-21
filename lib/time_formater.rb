class TimeFormater

  attr_reader :invalid_formats

  VALID_TIME_FORMATS = { "%G" => "year",  "%m" => "month", "%d" => "day", "%H" => "hour", "%M" => "minute", "%S" => "second" }

  def initialize(time_format)
    @valid_formats = []
    @invalid_formats = []
    @time_format = time_format
  end

  def call
    @time_format.each do |format|
      format_key = VALID_TIME_FORMATS.key(format)
      if format_key
        @valid_formats << format_key
      else
        @invalid_formats << format
      end
    end
  end

  def format_time
    Time.now.strftime(@valid_formats.join('-'))
  end

  def success?
    invalid_formats.empty?
  end

end
