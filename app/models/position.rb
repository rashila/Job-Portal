class Position
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :status, :type => String
  field :location, :type => String, :null =>false
  field :date_published, :type => Date, :null =>false
  field :last_date, :type => Date, :null =>false
  field :salary_range, :type => String
  field :skillset, :type => String
  field :qualification, :type => String
  field :experience, :type => String , :null => false
  validates_presence_of :title,:location,:description,:salary_range,:skillset,:qualification,:experience
  validates_numericality_of :salary_range, :message => "cannot be string/special character"
  
#  validates whether the last date is less than publishd date and the published day should be active on the day to be published
 validates :date_published, :date => { :after => Time.now }
  validates :last_date, :date => { :after => :date_published }
  #validates :on, :date => { :after => :end_date } 

  
 #validate :validate_last_date_before_date_published 
#  
#def validate_last_date_before_date_published
#       errors.add(:last_date, "cannot be less than or equal to published date") if (last_date < date_published)
#      
# end
  belongs_to :company
  
  
    
  end
  
  
  
