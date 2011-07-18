class Review
  include Mongoid::Document
  field :name, :type => String
  field :company_id, :type => String
  field :score, :type => Integer
end
