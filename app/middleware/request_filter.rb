require 'rack/throttle'

class RequestFilter < Rack::Throttle::Daily 
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    #tenant = Tenant.first.name
    [ 200, { "Content-Type" => "text/html" }, [ "#{tenant}" ] ]
  end

end