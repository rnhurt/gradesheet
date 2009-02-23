desc "Drop then recreate the dev database, migrate up, and load fixtures" 
task :remigrate => :environment do
  return unless %w[development test staging].include? RAILS_ENV
  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:fixtures:load"].invoke
end

