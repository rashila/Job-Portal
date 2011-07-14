class City
  include Mongoid::Document
  field :name,:type => String
  belongs_to :state
  has_and_belongs_to_many  :positions
  
end
