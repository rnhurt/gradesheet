Gem::Specification.new do |s|
  s.name    = 'validates_existence'
  s.version = '1.0.0'
  s.date    = '2009-01-17'
  
  s.summary     = 'Provides a validates_existence_of method for ActiveRecord models to check existence of records referenced by belongs_to associations'
  s.description = 'Provides a validates_existence_of method for ActiveRecord models to check existence of records referenced by belongs_to associations'
  
  s.author   = 'Josh Susser'
  s.homepage = 'http://github.com/shuber/validates_existence'
  
  s.has_rdoc = false
  
  s.files = %w(
    CHANGELOG
    init.rb
    lib/validates_existence.rb
    MIT-LICENSE
    Rakefile
    README.markdown
    shoulda_macros/validates_existence.rb
    test/helpers/table_test_helper.rb
    test/init.rb
  )
  
  s.test_files = %w(
    test/validates_existence_test.rb
  )
end