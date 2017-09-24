#require 'rack/throttle'

class RequestFilter #< Rack::Throttle::Daily 
  
  def initialize(app, message = "Response Time")
    @app = app
    @message = message
  end
  

  def call(env)
  	[200, { "Content-Type" => "application/json" }, "Hello, World" ]
  end
  
end