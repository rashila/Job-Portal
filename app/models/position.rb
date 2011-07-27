class Position
  require 'sunspot'
  require 'sunspot_rails' 
  # require 'sunspot_helper'
  # require 'mongoid'
  include Mongoid::Document

   
  include Sunspot::Mongoid 
 
  field :title, :type => String
  #field :company, :type => String
  field :description, :type => String
  field :status, :type => String
  field :published_status, :type => String
  field :city, :type => String
  field :date_published, :type => Date, :null =>false
  field :last_date, :type => Date, :null =>false
  field :salary_range, :type => String
  field :qualification, :type => String
  field :positionskillsets_id, :type => String
  field :positionagencies_id, :type => String
  field :experience, :type => String , :null => false
  validates_presence_of :title,:description,:salary_range,:qualification,:experience
  #validates_numericality_of :salary_range, :message => "cannot be string/special character"
  validates_presence_of :date_published,:last_date
#  validates whether the last date is less than publishd date and the published day should be active on the day to be published
  validates_date :date_published,   :is_at   => :today,:on => 'create'
  validates :last_date,:date => {:after => :date_published },:on => 'create'
  belongs_to :company
  belongs_to :candidate
  has_and_belongs_to_many  :skillsets
  #has_and_belongs_to_many  :cities
  references_and_referenced_in_many :agencies
  
    
 searchable :auto_index => false, :auto_remove => false do
      text :title,:boost => 2.0
      text :experience
      text :skillset_names do |post|
        post.skillsets.map{|skillset| skillset.id}
      end
      text :city 
      
      string :status
      string :published_status
      string :title, :stored => true
    end      

end
# Sunspot::Adapters::InstanceAdapter.register(SunspotHelper::InstanceAdapter, Position)
# 
# Sunspot::Adapters::DataAccessor.register(SunspotHelper::DataAccessor, Position)
# Sunspot.setup(Position) do
   # text :title, :boost => 2.0
   # text :experience
   # string :status
 # end

