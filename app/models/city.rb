class City
  include Mongoid::Document
  field :name,:type => String
  belongs_to :state
  #has_one :contactinfo
end
