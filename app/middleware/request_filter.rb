require 'rack/throttle'
require 'rack/attack'

class RequestFilter < Rack::Attack
  
  def initialize(app)
    options = {
       :code => 403,
       :message => "Api Request Limit Exceeded"
     }
    @app, @options = app, options
    api_auth_limits = Tenant.select('api_key')
    api_auth_limits.each do |a_l|
      Rails.cache.write(a_l.api_key, expires_in: TOKEN_LIMIT_EXPIRATION_MIN)
    end
    rescue 
      nil
  end
  
  def call(env)
    #request = Rack::Attack::Request.new(env)
    #binding.pry
    request = Rack::Request.new(env)
    token = get_token_val(request)
    request_available?(request) ? @app.call(env) : request_limit_exceeded(token)
  end

  def request_available?(request)
    @tenant = Tenant.find_by_api_key(request.env['HTTP_X_API_KEY']) rescue nil
    if @tenant.present?
      if @tenant.day_requests < 100 
        #use Rack::Throttle::Interval, :min => 10.0
        return true
      else
        
        Rack::Attack.throttle("ip", :limit => 1, :period => 10.second) { |req|
          #binding.pry
          
          req.ip
          #request_limit_exceeded(req.env["HTTP_X_API_KEY"])

        }
        #rack_attack = Rack::Attack.new()
        #binding.pry
        # request.throttle('req/ip', :limit => 1, :period => 20.second) do |req|
        #   binding.pry
        # end
      end

    end
  end

  def request_limit_exceeded(token)
    return [
          400, { "Content-Type" => "application/json" },
          [ @options.to_json ]
        ]
  end

  def get_token_val(request)
    request.env['HTTP_X_API_KEY']
  end

  # def max_per_second(request = nil)
  #   binding.pry
  #   return (options[:max_per_second] || options[:max] || 1) unless request
  #   if request.request_method == "POST"
  #     4
  #   else
  #     10
  #   end
  # end
  #alias_method :max_per_window, :max_per_second

end