require File.dirname(__FILE__) + '/../test_helper'

class GradingScaleTest < ActiveSupport::TestCase
	fixtures :grading_scales
	
	def setup
    @scale = GradingScale.first
    assert @scale.valid?, 'The initial scale is valid'
	end

	def teardown
	end

	def test_grading_scale_name_limits
		@scale.name = "This is a really long name that probably shouldn't be legal because it is too long"
		assert !@scale.valid?, "Name too long" 	

		@scale.name = ""
	 	assert !@scale.valid?, "Name too short"
	 	
	 	@scale.name = "New Scale"
	 	assert @scale.valid?, "Name just right" 	    
	end

  def test_grading_scale_cannot_have_duplicates
    dup_scale = GradingScale.create( :name => @scale.name.upcase )
    assert !dup_scale.save, "Duplicate Grading Scale is not valid"

    dup_scale = GradingScale.create( :name => @scale.name.downcase )
    assert !dup_scale.save, "Duplicate Grading Scale is not valid"
  end

end
