class TimeFormater

  attr_reader :invalid_formats, :format_error, :formated_time

  VALID_TIME_FORMATS = { "%G" => "year",  "%m" => "month", "%d" => "day", "%H" => "hour", "%M" => "minute", "%S" => "second" }

  def call(time_format)
    @time_format = time_format
    @invalid_formats = invalid_formats_list
    @format_error = format_error?
    @formated_time = format_time unless @format_error
  end

  def format_time
    ordered_time_parameters = []
    @time_format.each do |f|
      ordered_time_parameters << VALID_TIME_FORMATS.key(f)
    end
    Time.now.strftime(ordered_time_parameters.join('-'))
  end

  def invalid_formats_list
    invalid_formats_present = !@time_format&.all? { |e| VALID_TIME_FORMATS.values.include?(e) }
    invalid_formats_present ? (@time_format - VALID_TIME_FORMATS.values) : []
  end

  def format_error?
    invalid_formats.any?
  end

end
