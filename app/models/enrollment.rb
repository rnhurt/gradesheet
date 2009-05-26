# Contains the enrollment information for each course.
class Enrollment < ActiveRecord::Base
	belongs_to :student
	belongs_to :course

	validates_existence_of	:student
	validates_existence_of	:course

	validates_uniqueness_of :student_id, :scope =>  :course_id

end
