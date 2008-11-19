desc "Load fixtures data into the development database"
task :load_fixtures_data_to_development do
  require 'active_record/fixtures'
  ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations["development"])
  Fixtures.create_fixtures("test/fixtures",
      ActiveRecord::Base.configurations[:fixtures_load_order])
end

