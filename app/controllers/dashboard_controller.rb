class DashboardController < ApplicationController
	layout "standard"

	def index
		## Set the default teacher
		session[:user_id] = 918708696	# Kim
		#session[:user_id] = 842437485	# Bob
	end

end
