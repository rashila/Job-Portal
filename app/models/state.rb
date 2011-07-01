class State
  include Mongoid::Document
  field :name, :type => String
  field :contactinfos_id, :type => String
  has_many :cities
  has_and_belongs_to_many :contactinfos
end
