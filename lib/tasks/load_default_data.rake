desc 'Load Gradesheet default configuration data.'

namespace :gradesheet do
  task :load_default_data => :environment do
    begin
      Gradesheet::DefaultData::Loader.load()
      puts "Default configuration data loaded."
    rescue => error
      puts "Error: " + error
      puts "Default configuration data was not loaded."
    end
  end
end

