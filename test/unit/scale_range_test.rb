require File.dirname(__FILE__) + '/../test_helper'

class ScaleRangeTest < ActiveSupport::TestCase
	fixtures :grading_scales
	
	def setup
	  @scale = GradingScale.first
    assert @scale.save, 'The initial scale is valid'
	  
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


  
	def test_scale_range_description_limits
		@range.description = "This is a really long name that probably shouldn't be legal because it is too long. This is a really long name that probably shouldn't be legal because it is too long. This is a really long name that probably shouldn't be legal because it is too long."
		assert !@range.save, "Description too long"

		@range.description = nil
	 	assert !@range.save, "Description too short"
	 	
	 	@range.description = "Understanding of subject matter and demonstration of skills is Excellent."
	 	assert @range.save, "Name just right"
	end

  def test_scale_range_letter_grade_limits
    @range.letter_grade = "This is a really long name that probably shouldn't be legal because it is too long."
    assert !@range.save, "Letter grade too long"

    @range.letter_grade = ""
    assert !@range.save, "Letter grade too short"

    @range.letter_grade = "Pass"
    assert @range.save, "Letter grade just right"
  end

  def test_scale_range_max_score_limits
    @range.max_score = nil
    assert !@range.save, "Max Score is nil"

    @range.max_score = 'K'
    assert !@range.save, "Max Score is not a number"

    @range.max_score = -1
    assert !@range.save, "Max Score is negative"

    @range.max_score = 100000
    assert @range.save, "Max Score is pretty high"

    @range.max_score = 0
    @range.min_score = 0
    assert @range.save, "Max Score is very low, but still valid"

    @range.max_score = 80
    assert @range.save, "Max Score is normal"
  end
  
  def test_scale_range_min_score_limits
    @range.min_score = nil
    assert !@range.save, "Min Score is nil"

    @range.min_score = 'K'
    assert !@range.save, "Min Score is not a number"

    @range.min_score = -1
    assert !@range.save, "Min Score is negative"

    @range.max_score = 100000
    @range.min_score = 100000
    assert @range.save, "Min Score is pretty high"

    @range.min_score = 0
    assert @range.save, "Min Score is very low, but still valid"

    @range.min_score = 80
    assert @range.save, "Min Score is normal"
  end

  def test_scale_range_min_max_values
    @range.min_score = 50
    @range.max_score = 50
    assert @range.save, "Min & Max Score can be equal"

    @range.min_score = 50
    @range.max_score = 40
    assert !@range.save, "Min Score must be greater than Max Score"

    @range.min_score = 40
    @range.max_score = 50
    assert @range.save, "Min & Max Scores are valid"

    @range.min_score = 49.9999
    @range.max_score = 50.0000
    assert @range.save, "Min & Max Scores are just barely different"
  end
end
