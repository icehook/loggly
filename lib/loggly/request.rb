module Loggly
  class Request

    attr_accessor :resource_attributes, :method, :path_parts, :path_ext, :params, :klass, :request_account_id

    def initialize(resource_attributes, method, path_parts, path_ext, params = {}, options = {})
      @resource_attributes, @method, @path_parts, @path_ext, @params, @options = resource_attributes, method, path_parts, path_ext, params, options
      @request_account_id = @options[:account_id]
      @klass = @options[:klass]
    end

    def execute(connection)
      self.build_params!
      response = Response.new(self, connection.send(@method, self.build_path(@path_parts, @path_ext), @params, self.build_request_options))
    end

    def build_params!
      @params[:env] ||= {}
      @params[:env][:account_id] ||= @request_account_id if @request_account_id
    end

    def build_request_options
      {}.merge!(@resource_attributes[:request_options])
    end

    def build_path(parts = [], ext = '.json')
      parts.compact!
      parts.map!{ |p| p.to_s }

      "#{File.join(parts)}#{ext}"
    end

  end
end
