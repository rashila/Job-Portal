class EmailSetting
  include Mongoid::Document
  
  field :email, :type => String
  field :password, :type => String

  belongs_to :company
  validates_presence_of :email
  validates_format_of :email,:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "format is invalid"
  validates_uniqueness_of :email,:case_sensitive => false
  require 'crypt/blowfish' 
  
  def decrypted_password
    @crypto = Crypt::Blowfish.new('445f8261d565372d08f026fbb6b11ba3')
    password_decrypted = @crypto.decrypt_string([password].pack("H*"))
    "#{password_decrypted}"
  end
  
  def encrypted_password(password_str)
    @crypto = Crypt::Blowfish.new('445f8261d565372d08f026fbb6b11ba3')
    password_encrypted = @crypto.encrypt_string(password_str).unpack("H*").first
    "#{password_encrypted}"
  end
end
