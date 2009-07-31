class SchoolYear < DateRange
  has_many  :terms, :dependent => :destroy

  validates_length_of		:name, :within => 1..20
  validates_associated  :terms, :message => "are not correct."

  after_update :save_terms

  def new_term_attributes=(term_attributes)
    term_attributes.each do |attributes|
      terms.build(attributes)
    end
  end
  
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

  def save_terms
    terms.each do |term|
      term.save(false)
    end
  end
end