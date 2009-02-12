class DashboardController < ApplicationController
	layout "standard"

	def index
		## Set the default teacher
		session[:user_id] = 1069	# Kim
#		session[:user_id] = 1070	# Bob
	end

end
