module Loggly
  class Event < RemoteModel

    METADATA_KEYS = {
                      :total_count => :total_events,
                      :current_page => :page,
                    }

    set_resource_attributes({
                              :path_base => 'apiv2/',
                              :collection_name => 'events',
                              :index_method => 'events',
                              :path_ext => '',
                              :request_options => {
                              }
                            })

    def initialize(attributes = {})
      super
    end

    def self.all(conditions = {}, options = {}, &callback)
      conditions[:order] ||= "desc"
      conditions[:from] ||= "-24h"
      conditions[:until] ||= "now"

      unless rsid = options[:rsid]
        search = Search.create!(conditions, options)
        rsid = search.attributes.id
      end

      super({:rsid => rsid}, options, &callback)
    end

  end
end
