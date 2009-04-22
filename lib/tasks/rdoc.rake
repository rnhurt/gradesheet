namespace :doc do 
  desc "Generate documentation for the application"
  Rake::RDocTask.new("app_horo") { |rdoc|
    rdoc.rdoc_dir = 'doc/app_horo'
    rdoc.title    = "Gradesheet Documentation"
    rdoc.template = "doc/template/horo.rb"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README.rdoc')
    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
  }
end
