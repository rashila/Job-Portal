class CandidatePosition
  include Mongoid::Document
  field :position_id,:type => String
  field :candidate_id,:type => String
  field :title,:type => String
  field :apply_status,:type => String
  validates_uniqueness_of :title,:message => "has already been applied"
 
end
