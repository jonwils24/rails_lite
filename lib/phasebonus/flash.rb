require 'json'
require 'webrick'

module Phasebonus
  class Flash
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == "_rails_lite_app_flash" }
      @data = cookie.nil? ? {} : JSON.parse(cookie.value)
    end

    def [](key)
      @data[key]
    end

    def []=(key, val)
      @data[key.to_s] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new("_rails_lite_app_flash", @data.to_json)
    end
  end
end
