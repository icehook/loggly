module Loggly
  class Connection

    USER_AGENT = "loggly-client v#{Loggly::VERSION}"

    attr_accessor :options, :faraday

    def initialize(options = {})
      @options = options
      @faraday = self.create_faraday(@options[:uri], @options[:username], @options[:password]) if @options[:uri]
    end

    def create_faraday(uri, username = nil, password = nil)
      @faraday = Faraday.new uri do |c|
        c.headers['User-Agent'] = USER_AGENT

        Loggly.logger.info "username: #{username} password: #{password}"

        c.request :basic_auth, username, password unless (username.blank? || password.blank?)
        c.request :multipart
        c.request :url_encoded
        c.request :multi_json

        c.response :xml,  :content_type => /\bxml$/
        c.response :multi_json, symbolize_keys: true, :content_type => /\bjson$/
        c.response :loggly_response
        c.response :logger, Loggly.logger

        c.use :instrumentation
        c.adapter Faraday.default_adapter
      end
    end

    def request(method, path, params, options, &callback)
      sent_at = nil

      response = @faraday.send(method) { |request|
        sent_at = Time.now
        request = config_request(request, method, path, params, options)
      }.on_complete { |env|
        env[:total_time] = Time.now.utc.to_f - sent_at.utc.to_f if sent_at
        env[:request_params] = params
        env[:request_options] = options
        callback.call(env) if callback
      }

      response
    end

    def config_request(request, method, path, params, options)
      case method.to_sym
      when :delete, :get
        request.url(path, params)
      when :post, :put
        request.path = path
        request.body = params unless params.empty?
      end

      request
    end

    def get(path, params={}, options={}, &callback)
      request(:get, path, params, options, &callback)
    end

    def delete(path, params={}, options={}, &callback)
      request(:delete, path, params, options, &callback)
    end

    def post(path, params={}, options={}, &callback)
      request(:post, path, params, options, &callback)
    end

    def put(path, params={}, options={}, &callback)
      request(:put, path, params, options, &callback)
    end

  end
end
