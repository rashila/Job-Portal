class Skillset
  include Mongoid::Document
  field :name, :type => String
  #belongs_to :position
  has_and_belongs_to_many :candidates
  has_and_belongs_to_many :positions
  
  

end
