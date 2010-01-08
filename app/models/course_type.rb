class CourseType < ActiveRecord::Base
  has_many  :courses

  validates_size_of :name,  :within => 1..20

  named_scope :active, :conditions => { :active => true }
end
