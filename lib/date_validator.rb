def validates_date_of(*attr_names)
  validates_with DateValidator, _merge_attributes(attr_names)
end