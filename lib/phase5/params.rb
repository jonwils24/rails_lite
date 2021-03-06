require 'uri'

module Phase5
  class Params
    # use initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = {}
      
      @params.merge!(route_params)
      if req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # will return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      
      key_values = URI.decode_www_form(www_encoded_form)
      key_values.each do |k, v|
        scope = params
        
        key_seq = parse_key(k)
        key_seq.each_with_index do |el, i|
          if (i + 1) == key_seq.count
            scope[el] = v
          else
            scope[el] ||= {}
            scope = scope[el]
          end
        end
      end
      params
    end

    # return an array
    # user[address][street] 
    # will return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\[|\]\[|\]/)
    end
  end
end
