class Course < ActiveRecord::Base
	belongs_to	:teacher
	belongs_to	:term
	belongs_to	:course_type
	belongs_to	:grading_scale
	has_many		:assignments
	has_many		:enrollments
	has_many		:students, :through => :enrollments
	
	validates_existence_of :teacher, :message => "isn't a known teacher."
	validates_existence_of :term
	validates_existence_of :course_type
	validates_existence_of :grading_scale
	
	validates_length_of		:name, :in => 1..20

#	validates_uniqueness_of :teacher, :scope => [:term, :course]


	# FIXME
	named_scope	:students, :joins => :students, :conditions => { :course_id => 666 }

	## Find all courses belonging to a particular teacher
	def self.find_by_owner(*args)
		with_scope :find => { :conditions => { :teacher_id => args[1].id }} do
			find(*args)
		end
	end

end
