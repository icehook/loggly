module Loggly
  class Response

    METADATA_KEYS = {
                      :total_count => :total_count,
                      :current_page => :current_page,
                      :per_page => :per_page,
                      :offset => :offset,
                      :total_pages => :total_pages
                    }

    attr_accessor :request, :faraday_response, :metadata_keys

    def initialize(request, faraday_response)
      @request = request
      @faraday_response = faraday_response
      @metadata_keys = METADATA_KEYS
      add_metadata_keys(@request.klass::METADATA_KEYS) if defined? @request.klass::METADATA_KEYS
    end

    def env
      @faraday_response.env
    end

    def status
      self.env[:status]
    end

    def error_status?
      (400...600).include? self.status
    end

    def body
      self.env[:body]
    end

    def add_metadata_keys(keys = {})
      @metadata_keys.merge!(keys)
    end

    def metadata
      return @metadata if defined?(@metadata)

      if status == 200 && self.body.kind_of?(Hash)
        @metadata = {}.with_indifferent_access

        @metadata_keys.each do |k,v|
          if self.body.has_key?(v)
            @metadata[k] = self.body[v]
          elsif self.request.options.has_key?(k)
            @metadata[k] = self.request.options[v]
          end
        end

        @metadata
      end
    end

    def pages_left
      if self.metadata && self.metadata[:current_page] && self.metadata[:total_pages]
        self.metadata[:total_pages] - self.metadata[:current_page]
      elsif self.metadata && self.metadata[:current_page] && self.metadata[:total_pages].nil?
        self.total_pages - self.metadata[:current_page]
      else
        0
      end
    end

    def current_page
      self.metadata[:current_page] if self.metadata
    end

    def total_pages
      if self.metadata && !self.metadata[:total_pages].nil?
        self.metadata[:total_pages]
      else
        self.metadata[:total_count] / self.metadata[:per_page]
      end

    end

    def pages_left?
      self.current_page && self.total_pages ? (self.current_page < self.total_pages) : false
    end

    def to_models(&blk)
      self.build_models(@request.resource_attributes[:collection_name], @request.klass, &blk)
    end

    def to_model
      self.build_model(@request.resource_attributes[:collection_name], @request.klass)
    end

    def build_models(collection_name, klass, &blk)
      raise LogglyResponseException, 'could not create Models from Response' if self.error_status?

      models = []

      self.body[collection_name.to_sym].each do |h|
        if r = h[collection_name.singularize.to_sym]
          m = klass.send :from_hash, r
          m.response = self
          models << m
          blk.call(m) if blk
        else
          next
        end
      end

      models
    end

    def build_model(collection_name, klass)
      raise LogglyResponseException, 'could not create Model from Response' if self.error_status?

      model = nil

      if r = self.body[collection_name.singularize.to_sym]
        model = klass.send :from_hash, r
        model.response = self
      end

      model
    end

  end
end
