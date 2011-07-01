class State
  include Mongoid::Document
  field :name, :type => String
  has_many :cities
  #has_one :contactinfo
end
