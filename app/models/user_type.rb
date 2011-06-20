class UserType
  include Mongoid::Document
  field :title, :type => String
  has_many :user
end
