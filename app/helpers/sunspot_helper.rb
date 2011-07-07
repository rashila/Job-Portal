require 'rubygems'
require 'sunspot'

module SunspotHelper

  class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
    def id
      @instance.id
    end
  end

  class DataAccessor < Sunspot::Adapters::DataAccessor
    def load( id )
      @clazz.find(id) rescue nil

    end

    def load_all( ids )
      #redis = Redis.new
      @clazz.criteria.in(:_id => ids)

    end
  end

end
