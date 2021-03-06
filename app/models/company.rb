class Company
  include Mongoid::Document
  field :name, :type => String
  field :established_date, :type => Date
  field :website, :type => String
  field :description, :type => String
  field :contactinfos_id, :type => String
  field :user_id, :type => String
  
  has_many :contactinfos
  has_many :positions
  has_many :email_settings
  has_many :emails
  validates_presence_of :name,:established_date,:website,:description
  validates_date :established_date, :on_or_before => :today
  belongs_to :user
  #has_many :agencies
  validates_presence_of :name,:established_date,:website,:description

 # validates_format_of :established_date, :with =>/\A[0-9]{2}\/[0-9]{2}\/[0-9]{4}\z/
  #validates_format_of :name, :with =>/\A[a-zA-z]\z/
  has_many :reviews

end
