class Settings::TermsController < SettingsController
	layout "standard"

	def index
		@terms = Term.find(:all,
					:select => 'id, school_year, count(*) as total_terms, min(begin_date) as begin_date, max(end_date) as end_date',
					:group	=> 'school_year')
	end

	def show
	end
	
	def terms
	end
	
end
