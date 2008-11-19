class Teacher < User
	def full_name
		[first_name, last_name].join(' ')
	end
	
	def full_name=(name)
		split = name.split(' ', 2)
		self.first_name = split.first
		self.last_name = split.last
	end
end
