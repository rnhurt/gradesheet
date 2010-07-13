ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
   :due_date	=> lambda { |time| time.strftime("%a, %b #{time.day.ordinalize}") }
)
