namespace :db do
  desc "Erase and fill database with test data"
  task :populate => :environment do
    require 'populator'
    require 'faker'

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
    Teacher.populate 40 do |p|
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
    end
  end
end
