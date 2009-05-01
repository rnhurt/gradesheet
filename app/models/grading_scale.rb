# Contains the grading scale data used for each course.
class GradingScale < ActiveRecord::Base
	before_destroy	:ensure_no_children
  after_update  :save_ranges
  
	has_many	:courses
	has_many  :grade_ranges, :dependent => :destroy
	
	validates_length_of		  :name, :within => 1..20
	validates_uniqueness_of :name, :case_sensitive => false


  def range_attributes=(range_attributes)
    range_attributes.each do |attributes|
      if attributes[:id].blank?
        grade_ranges.build(attributes)
      else
        range = grade_ranges.detect { |r| r.id == attributes[:id].to_i }
        range.attributes = attributes
      end
    end
  end

private		

  def save_ranges
    grade_ranges.each do |r|
      if r.should_destroy?
        r.destroy
      else
        r.save(false)
      end
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
