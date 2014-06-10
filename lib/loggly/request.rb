module Loggly
  class Request

    attr_accessor :resource_attributes, :method, :path_parts, :path_ext, :params, :klass, :options

    def initialize(resource_attributes, method, path_parts, path_ext, params = {}, options = {})
      @resource_attributes, @method, @path_parts, @path_ext, @params, @options = resource_attributes, method, path_parts, path_ext, params, options
      @klass = @options[:klass]
    end

    def execute(connection)
      self.build_params!
      response = Response.new(self, connection.send(@method, self.build_path(@path_parts, @path_ext), @params, @options))
    end

    def build_params!
      @params ||= {}
    end

    def build_path(parts = [], ext = '.json')
      parts.compact!
      parts.map!{ |p| p.to_s }

      "#{File.join(parts)}#{ext}"
    end

  end
end
