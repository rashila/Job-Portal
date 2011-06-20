class Candidate
  include Mongoid::Document
  field :first_name, :type => String
  field :last_name, :type => String
  field :qualification, :type => String
  field :date_of_birth, :type => Date
  field :experience, :type => String
  field :expected_salary, :type => Float
  field :skill_set, :type => String
  field :contactinfos_id, :type => String
  #field :user_id,:value => 1
 # embeds_many :contactinfos
  has_many :contactinfos
  #key :contactinfos_id
  
  #def address
    #Contactinfo.where(:candidates_contactinfos_id =>self._id).all
    
  #end
   end
