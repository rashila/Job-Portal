class Contactinfo
  include Mongoid::Document
  field :address, :type => String
  field :email
  field :contact_number, :type => Float
  field :alternate_email
 # embedded_in :candidates
  belongs_to :candidate
  

end
