require 'pry'
require 'logger'
require 'faraday'
require 'ostruct'
require 'faraday_middleware'
require 'faraday_middleware/multi_json'
require 'multi_xml'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module'
require 'active_support/inflector'
require 'active_support/notifications'
require 'loggly/version'
require 'loggly/exceptions'
require 'loggly/logging'
require 'loggly/connection'
require 'loggly/request'
require 'loggly/response'
require 'loggly/model'
require 'loggly/remote_model'
require 'loggly/middleware/loggly_response_middleware'

module Loggly
  autoload :Event, 'loggly/models/event'
  autoload :Search, 'loggly/models/search'

  module ClassMethods
    def connection
      @connection ? @connection : (raise LogglyConnectionException)
    end

    def connect(config = {})
      @connection = Connection.new(:uri => config[:uri], :username => config[:username], :password => config[:password])
    end
  end

  extend ClassMethods
  extend Logging

  #MultiJson.use :yajl
  #Faraday.default_adapter = :excon

  Faraday::Response.register_middleware :loggly_response => lambda { LogglyResponseMiddleware }
end

ActiveSupport::Notifications.subscribe('request.faraday') do |name, start_time, end_time, _, env|
  url = env[:url]
  http_method = env[:method].to_s.upcase
  duration = end_time - start_time
  Loggly.logger.info '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration]
end
