namespace :tmp do
  namespace :system do
    desc "Clears all CSS & JS files in public/system "
    task :clear => %w(system:javascript system:css)

    task :javascript do
      FileUtils.rm(Dir['public/system/[^.]*.js'])
    end

    task :css do
      FileUtils.rm(Dir['public/system/[^.]*.css'])
    end
  end
end
