class Student < User
	validates_inclusion_of :class_of, :in => 2008..2010

end
