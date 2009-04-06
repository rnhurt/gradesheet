class SettingsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?
end
