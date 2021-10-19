
class TimeFormater

  VALID_TIME_FORMATS = { "%G" => "year",  "%m" => "month", "%d" => "day", "%H" => "hour", "%M" => "minute", "%S" => "second" }

  def initialize(time_format)
    @time_format = time_format
  end

  def formated_time
    ordered_time_parameters = []
    @time_format.each do |f|
      ordered_time_parameters << VALID_TIME_FORMATS.key(f)
    end
    Time.now.strftime(ordered_time_parameters.join('-'))
  end

  def valid_time_format?
    @time_format&.all? { |e| VALID_TIME_FORMATS.values.include?(e) }
  end

  def invalid_formats
    valid_time_format? ? [] : @time_format - VALID_TIME_FORMATS.values
  end

  def format_error?
    invalid_formats.any?
  end

end
