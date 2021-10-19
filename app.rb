require 'pry'

class App

  def call(env)
    perform_request
    [status, headers, body]
  end

  private


  def perform_request
    "request"
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    ["Welcome abort!\n"]
  end

end
