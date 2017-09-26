#require 'rack/throttle'
require 'rack/attack'

class RequestFilter < Rack::Attack
  
  def initialize(app)
    options = {
       :code => 403,
       :message => "Api Request Limit Exceeded"
     }
    @app, @options = app, options
    rescue 
      nil
  end
  
  def call(env)
    request = Rack::Request.new(env)
    if request.env['HTTP_ACCEPT'].include?("text/html")
      @app.call(env) 
    else
      token = get_token_val(request)
      request_available?(request) 
      @app.call(env)  
    end
  end

  def request_available?(request)
    @tenant = Tenant.find_by_api_key(request.env['HTTP_X_API_KEY']) rescue nil
    if @tenant.present?
      if @tenant.day_requests < 100 
        return true
      else
        Rack::Attack.throttle("ip", :limit => 1, :period => 10.seconds) { |req|
          req.ip
        }
      end
    end
  end

  def get_token_val(request)
    request.env['HTTP_X_API_KEY']
  end

end