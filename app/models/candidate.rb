
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
  field :candidateskills_id, :type => String
  field :phd,:type => String
  field :pg,:type => String
  field :graduate,:type => String
  validates_presence_of :first_name,:last_name,:date_of_birth,:experience,:expected_salary
  validates_date :date_of_birth, :before => lambda { 18.years.ago },
                                 :before_message => "must be at least 18 years old"


  has_many :contactinfos
  has_and_belongs_to_many :skillsets
  has_many :positions
  has_many :companies
  
  
  belongs_to :user

  accepts_nested_attributes_for :contactinfos, :allow_destroy => true
  
#File upload
mount_uploader :resume, ResumeUploader


  def name
    "#{first_name} #{last_name}"
  end
 
   


end
