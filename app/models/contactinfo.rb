class Contactinfo
  include Mongoid::Document
  field :address, :type => String
  field :email
  field :contact_number, :type => Integer
  field :alternate_email
 # embedded_in :candidates
  belongs_to :candidate
  belongs_to :company
  validates_presence_of :address,:contact_number,:email,:alternate_email
  validates_uniqueness_of :email,:case_sensitive => false


end
