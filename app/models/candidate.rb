
class Candidate
  
  include Mongoid::Document
  #include Mongoid::Paperclip

  field :first_name, :type => String
  field :last_name, :type => String
  field :qualification, :type => String
  field :date_of_birth, :type => Date
  field :experience, :type => String
  field :expected_salary, :type => String
  field :contactinfos_id, :type => String
  field :user_id, :type => String
  
  validates_presence_of :first_name,:last_name,:qualification,:date_of_birth,:experience,:expected_salary
  #field :user_id,:value => 1
 # embeds_many :contactinfos
  has_many :contactinfos
  has_and_belongs_to_many :skillsets
  
  belongs_to :user

  accepts_nested_attributes_for :contactinfos, :allow_destroy => true
  #scope :skillset.joins(",")

#File upload
mount_uploader :resume, ResumeUploader


  #key :contactinfos_id
  #def address
    #Contactinfo.where(:candidates_contactinfos_id =>self._id).all
    
  #end
  def name
    "#{first_name} #{last_name}"
  end
 
   

  


end
