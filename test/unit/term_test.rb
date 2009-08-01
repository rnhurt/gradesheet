require File.dirname(__FILE__) + '/../test_helper'

class TermTest < ActiveSupport::TestCase
  fixtures :all
  
	def setup
    @term = Term.first
    assert @term.valid?, 'The initial term is valid'
	end

	def teardown
	end

	def test_term_name_length
		@term.name = "This is a really long term name that probably shouldn't be legal because it is too long"
  	assert !@term.valid?, "Term name too long" 	

		@term.name = ""
	 	assert !@term.valid?, "Term name too short" 	

		@term.name = "Term #2"
		assert @term.valid?, "Term name is just right"		
  end
end
