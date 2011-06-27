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
  validates_format_of :email,:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => [:create,:edit],:message => "invalid email format"
  validates_format_of :alternate_email,:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => [:create,:edit],:message => "invalid email format for Alternate email"
 validates_numericality_of :contact_number, :message => "should contain numbers "
end
