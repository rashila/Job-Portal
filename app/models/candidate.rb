class Candidate
  include Mongoid::Document
  field :first_name, :type => String
  field :last_name, :type => String
  field :qualification, :type => String
  field :date_of_birth, :type => Date
  field :experience, :type => String
  field :expected_salary, :type => String
  field :skill_set, :type => String
  field :contactinfos_id, :type => String
  #validates_uniqueness_of :first_name
  validates_presence_of :first_name,:last_name,:qualification,:date_of_birth,:experience,:expected_salary,:skill_set
  #field :user_id,:value => 1
 # embeds_many :contactinfos
  has_many :contactinfos
  accepts_nested_attributes_for :contactinfos, :allow_destroy => true

  #key :contactinfos_id
  #def address
    #Contactinfo.where(:candidates_contactinfos_id =>self._id).all
    
  #end
  def name
    "#{first_name} #{last_name}"
  end
  
 


end
