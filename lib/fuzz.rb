class Fuzz
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # This file location varies by OS. This is the Mac OS X location.
  # At 2.4M, you have plenty of RAM to read it all into memory!
  @@words = File.open("/usr/share/dict/words").collect do |line|
    line.strip
  end
  
  def self.execute(size)
    if size == 0 or size.nil?
      size = 100
    end

    ActiveRecord::Base.silence {
      User.transaction do
        size.times do
          student = Student.find(:first, :order => "rand()")
          student.create!(:first_name => random_words(rand(5))
        end
        puts "Created #{size} students"
      end
    }
  end
  
  # provide a string with num random words in it.
  def self.random_words(num = 1)
    w = []
    num.times do
      w << @@words[rand(@@words.size)]
    end
    w.join(" ")
  end
  
end