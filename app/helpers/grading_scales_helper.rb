module GradingScalesHelper

  def fields_for_range(range, &block)
    prefix = range.new_record? ? 'new' : 'existing'
    fields_for("grading_scale[#{prefix}_range_attributes][]", range, &block)
  end
  
end
