class Agency
  include Mongoid::Document
  field :name, :type => String
  field :established_date, :type => Date
  field :website, :type => String
  field :description, :type => String
  field :contactinfos_id, :type => String
  field :user_id, :type => String
  
  has_many :contactinfos
  belongs_to :user
  has_and_belongs_to_many  :positions
  validates_presence_of :name,:established_date,:website,:description
  validates_date :established_date, :on_or_before => :today
end
