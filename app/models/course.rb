class Course < ActiveRecord::Base
	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:course_type
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:students, :through => :enrollments
	
	validates_existence_of :teacher, :message => "%s wasn't found"
	validates_existence_of :term
	validates_existence_of :course_type
	validates_existence_of :grading_scale
	
	validates_presence_of :name

	def self.find_by_owner(*args)
		with_scope :find => { :conditions => { :teacher_id => args[1].id } } do
			find(*args)
		end
	end

end
