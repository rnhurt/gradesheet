class Enrollment < ActiveRecord::Base
	belongs_to :student
	belongs_to :course

	validates_presence_of :student, :message => "is not in the database"
	validates_presence_of :course, :message => "is not in the database"
end
