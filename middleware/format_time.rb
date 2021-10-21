require_relative '../lib/time_formater'

class FormatTime

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    build_response(env)
  end

  private

  def build_response(params)
    request = Rack::Request.new(params)

    if invalid_request?(request)
      response(404, 'invalid path')
    else
      handle_request(request)
    end
  end

  def handle_request(request)
    request_time_format = request.params['format']&.split(',')
    time_formater = TimeFormater.new(request_time_format)
    time_formater.call
    if time_formater.success?
      response(200, time_formater.format_time)
    else
      response(400, time_formater.invalid_formats)
    end
  end

  def response(status, body)
    [
      status,
      { "Content-Type" => "text/plain" },
      ["#{body}\n"]
    ]
  end

  def invalid_request?(request)
    [
      request.get?,
      request.path == '/time'
    ].include?(false)
  end

end


