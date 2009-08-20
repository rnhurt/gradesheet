require File.dirname(__FILE__) + '/../test_helper'

class ScaleRangeTest < ActiveSupport::TestCase
	fixtures :grading_scales
	
	def setup
	  @scale = GradingScale.first
    assert @scale.valid?, 'The initial scale is valid'
	  
    @range = @scale.scale_ranges.new(
      :grading_scale_id => 119,
      :letter_grade     => 'A',
      :description      => 'Understanding of subject matter is Excellent.',
      :max_score        => '100',
      :min_score        => '93')
    assert @range.save, 'The initial range is valid'
	end

	def teardown
	end

#  This relationship no longer exists
#  def test_scale_range_grading_scale_id
#    @range.grading_scale_id = nil
#    assert !@range.valid?, "Grading Scale is not valid"
#
#    @range.grading_scale_id = -300
#    assert !@range.valid?, "Grading Scale is not valid"
#
#    @range.grading_scale_id = @scale.id
#    assert @range.valid?, "Grading Scale is valid"
#  end
  
	def test_scale_range_description_limits
		@range.description = "This is a really long name that probably shouldn't be legal because it is too long. This is a really long name that probably shouldn't be legal because it is too long. This is a really long name that probably shouldn't be legal because it is too long."
		assert !@range.valid?, "Descrpition too long" 	

		@range.description = nil
	 	assert !@range.valid?, "Description too short"
	 	
	 	@range.description = "Understanding of subject matter and demonstration of skills is Excellent."
	 	assert @range.valid?, "Name just right" 	    
	end

  def test_scale_range_letter_grade_limits
    @range.letter_grade = "This is a really long name that probably shouldn't be legal because it is too long."
    assert !@range.valid?, "Letter grade too long"

    @range.letter_grade = ""
    assert !@range.valid?, "Letter grade too short"

    @range.letter_grade = "Pass"
    assert @range.valid?, "Letter grade just right"
  end

  def test_scale_range_max_score_limits
    @range.max_score = nil
    assert @range.valid?, "Max Score is nil"

    @range.max_score = 'K'
    assert !@range.valid?, "Max Score is not a number"

    @range.max_score = -1
    assert !@range.valid?, "Max Score is negative"

    @range.max_score = 100000
    assert @range.valid?, "Max Score is pretty high"

    @range.max_score = 0
    assert @range.valid?, "Max Score is very low"

    @range.max_score = 80
    assert @range.valid?, "Max Score is normal"
  end
  
  def test_scale_range_min_score_limits
    @range.min_score = nil
    assert @range.valid?, "Min Score is nil"

    @range.min_score = 'K'
    assert !@range.valid?, "Min Score is not a number"

    @range.min_score = -1
    assert !@range.valid?, "Min Score is negative"

    @range.min_score = 100000
    assert @range.valid?, "Min Score is pretty high"

    @range.min_score = 0
    assert @range.valid?, "Min Score is very low"

    @range.min_score = 80
    assert @range.valid?, "Min Score is normal"
  end
end
