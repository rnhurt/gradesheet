namespace :db do
  desc "Erase and fill database with test data"
  task :populate => :environment do
    require 'populator'
    require 'faker'


    # CONSTANTS - change these as needed for your testing purposes
    CURRENT_YEAR    = Time.now.year   # Year to consider the current school year
    MAX_YEARS       = 9               # How many school years you want to inject
    NUMBER_OF_TERMS = 3               # Number of school terms you have per school year

    
    puts 'Building SchoolYear & Term records...'
    Term.delete_all
    SchoolYear.delete_all

    year_index = 0
    SchoolYear.populate MAX_YEARS do |s|
      s.name = "#{CURRENT_YEAR - year_index - 1} - #{CURRENT_YEAR - year_index}"

      year_index += 1
      term_index = 0
      term_start_date = "#{CURRENT_YEAR - year_index}/8/15".to_date

      Term.populate NUMBER_OF_TERMS do |p|
        p.id    = Faker.numerify '##########'   # Since these models are STI their IDs are overlapping.  :(
        p.name    = "Term #{term_index}"
        p.active  = (0 == term_index) && (1 == year_index)

        p.begin_date  = term_start_date >> (9 / NUMBER_OF_TERMS) * term_index
        p.end_date    = (p.begin_date >> (9 / NUMBER_OF_TERMS)) - 1.day

        p.school_year_id = s.id

        term_index += 1
      end
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

    puts 'Building Teacher Assistant records...'
    TeacherAssistant.delete_all
    TeacherAssistant.populate (0.25 * Teacher.count).to_i do |p|
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
    Student.populate 100 * MAX_YEARS do |p|
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
    
    puts "Building out fixed user accounts..."
    ['teacher a', 'teacher b', 'admin'].each do |u|
      fullname = u.split.join('')
      Teacher.create!(
        :site_id    => Site.first.id,
        :first_name => u.split.first.capitalize,
        :last_name  => u.split.last.capitalize,
        :login      => fullname,
        :email      => "#{fullname}@example.com",
        :password   => fullname,
        :password_confirmation   => fullname,
        :active     => true,
        :is_admin   => 'admin' == u ? true : false
      )
    end
    ['student a', 'student b'].each do |u|
      fullname = u.split.join('')
      Student.create!(
        :site_id    => Site.first.id,
        :first_name => u.split.first.capitalize,
        :last_name  => u.split.last.capitalize,
        :login      => fullname,
        :email      => "#{fullname}@example.com",
        :password   => fullname,
        :password_confirmation   => fullname,
        :active     => true,

        :homeroom => Student.first.homeroom,
        :class_of => Student.first.class_of
      )
    end
  end
end
