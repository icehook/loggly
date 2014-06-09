module Loggly
  class Event < RemoteModel

    set_resource_attributes({
                              :path_base => 'apiv2/',
                              :collection_name => 'events',
                              :index_method => 'events',
                              :size => 50,
                              :path_ext => '',
                              :request_options => {
                              }
                            })

    def initialize(attributes = {})
      super
    end

    def self.all(conditions = {}, options = {}, &callback)
      search = Search.create!(conditions, options)

      super({:rsid => search.attributes.id}, options, &callback)
    end

  end
end
