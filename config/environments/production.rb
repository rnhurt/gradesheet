# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
# FIXME - this is a work-around for weird migration failures on PostgreSQL.  Should be fixed in Rails 2.3
#    http://code.google.com/p/activescaffold/issues/detail?id=638#c1
config.cache_classes = (File.basename($0) == "rake" && ARGV.include?("db:migrate")) ? false : true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true

# Cache to the disk
config.cache_store = :file_store, File.join(RAILS_ROOT, 'tmp', 'cache')

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
