module Loggly
  class RemoteModel < Model

    DEFAULT_RESOURCE_ATTRIBUTES = {
      :path_base => nil,
      :path_ext => nil,
      :index_method => nil,
      :collection_name => '',
      :per_page => 25,
      :request_options => {}
    }

    @resource_attributes = DEFAULT_RESOURCE_ATTRIBUTES

    module ClassMethods
      attr_reader :resource_attributes

      def path_ext;@resource_attributes[:path_ext];end
      def index_method;@resource_attributes[:index_method];end
      def collection_name;@resource_attributes[:collection_name];end

      def set_resource_attributes(ra)
        @resource_attributes = DEFAULT_RESOURCE_ATTRIBUTES.merge(ra)
      end

      def path_base(params = {})
        pb = @resource_attributes[:path_base] || File.join('/', @resource_attributes[:collection_name])
        params.each { |k,v| pb.gsub!(":#{k}", v) } unless params.blank?
        pb
      end

      def all(conditions = {}, options = {}, &callback)
        options = options.merge(:klass => self)
        params = conditions
        params[:size] = (options[:per_page] ||= @resource_attributes[:per_page])
        params[:page] = (options[:page] ||= 0)

        response = Request.new(@resource_attributes, :get, [path_base, index_method], path_ext, params, options).execute(Loggly.connection)
        models = response.to_models

        callback.call(models) if callback

        models
      end

      def prepare_params(conditions = {}, options = {})
        params = {}

        params[:q] = if conditions[:q].kind_of?(Hash)
          conditions[:q].map { |condition| condition.join(':') }.join(' AND ')
        else
          '*'
        end

        params
      end

      def where(conditions = {}, options = {}, &callback)
        self.all(conditions, options, &callback)
      end

      def find(id, options = {}, &callback)
        options.merge(:klass => self)

        response = Request.new(@resource_attributes, :get, [path_base, id.to_s], path_ext, {}, options).execute(Loggly.connection)
        model = response.to_model

        callback.call(models) if callback

        model
      end

      def create!(attributes = {}, options = {}, &callback)
        raise NotImplementedError
      end
    end

    extend ClassMethods
  end
end
