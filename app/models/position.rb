class Position
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :status, :type => String, :null => false
  field :location, :type => String, :null =>false
  field :date_published, :type => Date
  field :last_date, :type => Date
  field :salary_range, :type => String
  field :skillset, :type => String
  field :qualification, :type => String
  field :count, :type => Integer
  field :experience, :type => String , :null => false
  field :working_time, :type => String, :null => false
  validates_presence_of :title,:status,:location,:description,:date_published,:last_date,:salary_range,:skillset,:qualification,:experience,:working_time,:count
  validates_numericality_of :salary_range, :message => "Salary cant be string/special character"
  belongs_to :company
  
  
    
  end
  
  
  
