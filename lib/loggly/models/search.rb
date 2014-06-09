module Loggly
  class Search < RemoteModel

    set_resource_attributes({
                              :path_base => 'apiv2/',
                              :collection_name => 'rsid',
                              :index_method => 'search',
                              :path_ext => '',
                              :request_options => {
                              }
                            })

    def initialize(attributes = {})
      super
    end

    def self.create!(conditions = {}, options = {}, &callback)
      options.merge!(:klass => self)
      params = conditions

      response = Request.new(@resource_attributes, :get, [path_base, index_method], path_ext, params, options).execute(Loggly.connection)

      model = response.to_model

      callback.call(model) if callback

      model
    end

  end
end
