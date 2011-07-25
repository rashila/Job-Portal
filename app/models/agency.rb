class Agency
  include Mongoid::Document
  field :name, :type => String
  field :established_date, :type => Date
  field :website, :type => String
  field :description, :type => String
  field :contactinfos_id, :type => String
  field :user_id, :type => String
  #belongs_to :company
  has_many :contactinfos
  belongs_to :user
  references_and_referenced_in_many :positions
  validates_presence_of :name,:established_date,:website,:description
  validates_date :established_date, :on_or_before => :today
end
 
  
  
  # def delete_from_agency
    # Agency.any_in(:positons_ids => [self.id]).each do |a|
      # a.related.delete(self)
      # a.save
    # end
  # end