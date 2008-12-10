class Student < User
	has_many	:enrollments
	has_many	:courses, :through => :enrollments
	
	from_year = Time.now.year - 1
	to_year = from_year + 10
	validates_inclusion_of :class_of, :in => from_year..to_year, 
												:message => "must be in the range of #{from_year} to #{to_year}"



	## Find all students in a particular class
	def self.find_by_class(*args)
		with_scope :find => { :conditions => { :class_of => args[1] }, :order => "name ASC" } do
			find(*args)
		end
	end

end
