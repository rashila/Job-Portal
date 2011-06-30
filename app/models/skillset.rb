class Skillset
  include Mongoid::Document
  field :name, :type => String
  belongs_to :position
end
