# Contains the grading scale data used for each course.
class GradingScale < ActiveRecord::Base
	before_destroy	:ensure_no_children
  after_update  :save_ranges
  
	has_many	:courses
	has_many  :scale_ranges, :dependent => :destroy
	
	validates_length_of     :name, :within => 1..20
	validates_uniqueness_of :name, :case_sensitive => false
	validates_associated    :scale_ranges

  named_scope :active, :conditions => { :active => true }

  # Calculate a letter grade based on the score and the grading scale
  def calculate_letter_grade(score)
    letter_grade = ''
    self.scale_ranges.sort{ |a,b| a.max_score <=> b.max_score }.map {|range|
      letter_grade = range.letter_grade if score > range.min_score
    }

    return letter_grade
  end

  # Save new grade ranges
  def new_range_attributes=(range_attributes)
    range_attributes.each do |attributes|
      scale_ranges.build(attributes)
    end
  end

  # Save changes to existing grade ranges
  def existing_range_attributes=(range_attributes)
    scale_ranges.reject(&:new_record?).each do |range|
      attributes = range_attributes[range.id.to_s]
      if attributes
        range.attributes = attributes
      else
        scale_ranges.delete(range)
      end
    end
  end


private		

  def save_ranges
    scale_ranges.each do |range|
        range.save(false)
    end
  end

  # Ensure that the user does not delete a record without first cleaning up
  # any records that use it.  This could cause a cascading effect, wiping out
  # more data than expected.	
	def ensure_no_children
		unless self.courses.empty?
			self.errors.add_to_base "You must remove all Courses before deleting."
			raise ActiveRecord::Rollback
		end
	end

end