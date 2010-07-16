namespace :db do
  desc "Erase and fill database with test data"
  task :populate => :environment do
    require 'populator'
    require 'faker'


    # CONSTANTS - change these as needed for your testing purposes
    CURRENT_YEAR    = Time.now.year   # Year to consider the current school year
    MAX_YEARS       = 9               # How many school years you want to inject
    NUMBER_OF_TERMS = 3               # Number of school terms you have per school year


    puts 'Building SchoolYear records...'
    SchoolYear.delete_all
    counter = 0
    SchoolYear.populate MAX_YEARS do |p|
      p.name    = "#{CURRENT_YEAR - counter - 1} - #{CURRENT_YEAR - counter}"
      p.active  = 0 == p.id ? true : false
      p.begin_date  = "#{CURRENT_YEAR - counter}/1/1".to_date
      p.end_date    = "#{CURRENT_YEAR - counter}/12/31".to_date

      p.active = 0 == counter ? true : false  # Only the most recent year is active
      counter = counter + 1
    end


    puts 'Building Site records...'
    Site.delete_all
    Site.populate 1 do |p|
      p.name    = 'Main Campus'
      p.active  = true
    end
    Site.populate 5 do |p|
      p.name    = "#{Faker::Address.city } Campus"
      p.active  = [true, false]
    end
    
    puts 'Building Teacher records...'
    Teacher.delete_all
    Teacher.populate 4 * MAX_YEARS do |p|
      p.site_id     = Site.first.id
      p.first_name  = Faker::Name.first_name
      p.last_name   = Faker::Name.last_name
      p.login       = Faker::Internet.user_name
      p.email       = Faker::Internet.email
      p.login_count = 10..1000
      p.failed_login_count = 0..5
      p.active      = [true, true, true, true, false]

      salt = Authlogic::Random.hex_token
      p.password_salt       = salt
      p.crypted_password    = Authlogic::CryptoProviders::Sha512.encrypt(p.last_name + salt)
      p.persistence_token   = Authlogic::Random.friendly_token
      p.single_access_token = Authlogic::Random.friendly_token
      p.perishable_token    = Authlogic::Random.friendly_token

      p.class_of  = ''
      p.homeroom  = ''
    end

    puts 'Building Student records...'
    Student.delete_all
    current_class_of = CURRENT_YEAR
    Student.populate 40 * MAX_YEARS do |p|
      p.site_id     = Site.first.id
      p.first_name  = Faker::Name.first_name
      p.last_name   = Faker::Name.last_name
      p.login       = Faker::Internet.user_name
      p.email       = Faker::Internet.email
      p.login_count = 10..1000
      p.failed_login_count = 0..5

      salt = Authlogic::Random.hex_token
      p.password_salt       = salt
      p.crypted_password    = Authlogic::CryptoProviders::Sha512.encrypt(p.last_name + salt)
      p.persistence_token   = Authlogic::Random.friendly_token
      p.single_access_token = Authlogic::Random.friendly_token
      p.perishable_token    = Authlogic::Random.friendly_token

      p.homeroom  = %w[1A 2B 3C 4D 5E 6F]

      # Give each school year about 500 students
      current_class_of = current_class_of - 1 if p.id % 500 == 0
      p.class_of  = current_class_of

      # Make sure that old classes are marked as archived (active = false)
      p.active    = current_class_of > CURRENT_YEAR - 9 ? [true, true, true, true, true, true, false] : false
    end


  end
end
