class Email
  include Mongoid::Document
  field :from, :type => String
  field :to, :type => String
  field :resume_file, :type => String
  field :company_id, :type => String
  field :date_received, :type => Date
  belongs_to :company
end
