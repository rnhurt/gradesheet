class SchoolYear < DateRange
  after_update :save_terms

  has_many  :terms, :dependent => :destroy

  validates_length_of		:name, :within => 1..20
  validates_associated  :terms, :message => "are not correct."

  named_scope :current, :conditions => { "id" => Term.current.first.school_year_id }

  
  # Calculate the beginning of the school year by finding the begin date of the
  # first term in the school year
  def begin_date
    self.terms.sort{|a,b| a.end_date <=> b.end_date}.first.begin_date
  end

  # Calculate the end of the school year by finding the end date of the
  # last term in the school year
  def end_date
    self.terms.sort{|a,b| a.end_date <=> b.end_date}.last.end_date
  end
  
  # Create new terms for this school year
  def new_term_attributes=(term_attributes)
    term_attributes.each do |attributes|
      terms.build(attributes)
    end
  end

  # Update the existing terms for this school year
  def existing_term_attributes=(term_attributes)
    terms.reject(&:new_record?).each do |term|
      attributes = term_attributes[term.id.to_s]
      if attributes
        term.attributes = attributes
      else
        terms.delete(term)
      end
    end
  end

  # Make sure the terms save without validation
  def save_terms
    terms.each do |term|
      term.save(false)
    end
  end
end