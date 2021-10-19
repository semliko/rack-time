class FormatTime

  VALID_TIME_FORMATS = { "%G" => "year",  "%m" => "month", "%d" => "day", "%H" => "hour", "%M" => "minute", "%S" => "second" }

  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    status, headers, body = @app.call(env)
    @time_formater = TimeFormater.new(request_time_format)
    build_response
    [@status, headers, @body]
  end

  private


  def build_response
    if errors?
      error_response
    else
      formated_time_response
    end
  end

  def errors?
    [
      valid_request?,
      @time_formater.valid_time_format?
    ].include?(false)
  end

  def error_response
    if !valid_request?
      @status = 404
    elsif !@time_formater.valid_time_format?
      @status = 400
      @body = ["Unknown time format #{@time_formater.invalid_formats}\n"]
    end
  end

  def formated_time_response
    @status = 200
    @body = ["#{formated_time}\n"]
  end

  #  def invalid_formats
  #    time_format - VALID_TIME_FORMATS.values
  #  end

  def request_time_format
    @request.params['format']&.split(',')
  end

  #def valid_time_format?
  #  time_format&.all? { |e| VALID_TIME_FORMATS.values.include?(e) }
  #end

  def valid_request?
    @request.get? && @request.path == '/time'
  end

  #def formated_time
  #  ordered_time_parameters = []
  #  time_format.each do |f|
  #    ordered_time_parameters << VALID_TIME_FORMATS.key(f)
  #  end
  #  Time.now.strftime(ordered_time_parameters.join('-'))
  #end

end


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
    @time_format - VALID_TIME_FORMATS.values
  end
end
