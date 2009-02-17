namespace :db do
  desc 'Insert some random posts'
  task :fuzz => :environment do
    if RAILS_ENV.downcase == "production"
      raise "You can't fuzz your production environment. Think of the children!"
    end
    
    Fuzz.execute(ENV['SIZE'].to_i)
    
  end
end