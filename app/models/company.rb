class Company
  include Mongoid::Document
  field :name, :type => String
  field :business_type, :type => String
  field :established_date, :type => Date
  field :employee_count, :type => Integer
  field :website, :type => String
  field :desciption, :type => String
  has_many :contact_info
end
