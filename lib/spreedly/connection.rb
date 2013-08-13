require 'net/http'
require 'net/https'

module Spreedly
  class Connection

    attr_accessor :endpoint

    def initialize(endpoint)
      @endpoint = URI.parse(endpoint)
    end

    def request(method, body, headers = {})
      case method
      when :get
        http.get(endpoint.request_uri, headers)
      when :post
        http.post(endpoint.request_uri, body, headers)
      when :put
        http.put(endpoint.request_uri, body, headers)
      when :delete
        http.delete(endpoint.request_uri, headers)
      else
        raise ArgumentError, "Unsupported request method #{method.to_s.upcase}"
      end
    end

    private
    def http
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.open_timeout = 70
      http.read_timeout = 70
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_file = File.dirname(__FILE__) + '/../certs/cacert.pem'
      http
    end
  end
end
