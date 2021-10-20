require_relative '../lib/time_formater'

class FormatTime

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    response(status, headers, body, env)
  end

  private

  def response(status, headers, body, env)
    request = Rack::Request.new(env)
    request_time_format = request.params['format']&.split(',')
    time_formater = TimeFormater.new
    time_formater.call(request_time_format)

    if invalid_request?(request)
      status = 404
      body = ["Error\n"]
    elsif time_formater.format_error
      status = 400
      body = ["Unknown time format #{time_formater.invalid_formats}\n"]
    else
      status = 200
      body = ["#{time_formater.format_time}\n"]
    end
    [status, headers, body]
  end

  def invalid_request?(request)
    [
      request.get?,
      request.path == '/time'
    ].include?(false)
  end

end


