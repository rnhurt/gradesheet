module SchoolYearsHelper
  def fields_for_term(term, &block)
    prefix = term.new_record? ? 'new' : 'existing'
    fields_for("school_year[#{prefix}_term_attributes][]", term, &block)
  end
end