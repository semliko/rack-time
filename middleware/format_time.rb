require_relative '../lib/time_formater'

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
      invalid_request?,
      @time_formater.format_error?
    ].include?(true)
  end

  def error_response
    if invalid_request?
      @status = 404
    elsif @time_formater.format_error?
      @status = 400
      @body = ["Unknown time format #{@time_formater.invalid_formats}\n"]
    end
  end

  def formated_time_response
    @status = 200
    @body = ["#{@time_formater.formated_time}\n"]
  end

  def request_time_format
    @request.params['format']&.split(',')
  end

  def invalid_request?
    [
      @request.get?,
      @request.path == '/time'
    ].include?(false)
  end

end


