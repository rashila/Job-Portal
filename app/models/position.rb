class Position
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :status, :type => String
  
  field :date_published, :type => Date, :null =>false
  field :last_date, :type => Date, :null =>false
  field :salary_range, :type => String
  field :skillset, :type => String
  field :qualification, :type => String
  field :experience, :type => String , :null => false
  field :company_id ,:type => String
  validates_presence_of :title,:description,:salary_range,:skillset,:qualification,:experience
  #validates_numericality_of :salary_range, :message => "cannot be string/special character"
  validates_presence_of :date_published,:last_date
#  validates whether the last date is less than publishd date and the published day should be active on the day to be published
   validates_date :date_published,  :on_or_after => :today
   validates :last_date,:date => {:after => :date_published }
  belongs_to :company
  
  
    
  end
  
  
  
