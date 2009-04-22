# Subclass of User that handles the Teacher users
class Teacher < User
	has_many :courses
	
end
