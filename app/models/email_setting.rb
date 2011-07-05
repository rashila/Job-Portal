class EmailSetting
  include Mongoid::Document
  field :email, :type => String
  field :password, :type => String
  belongs_to :company
  validates_presence_of :email
  validates_format_of :email,:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "format is invalid"
end
