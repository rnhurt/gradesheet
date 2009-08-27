class SchoolYear < DateRange
  after_update :save_terms

  has_many  :terms, :dependent => :destroy

  validates_length_of		:name, :within => 1..20
  validates_associated  :terms, :message => "are not correct."

  # Find the current school year
  named_scope :current, lambda { {
      :select     => "DISTINCT date_ranges.*",
      :conditions => ["? BETWEEN terms_date_ranges.begin_date AND terms_date_ranges.end_date", Date.today],
      :joins      => "INNER JOIN date_ranges terms_date_ranges on terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = 'Term' AND date_ranges.type = 'SchoolYear'"
    } }


  # Find all school years that contain active terms
  named_scope :active,
    :select     => "DISTINCT date_ranges.*",
    :joins      => "INNER JOIN date_ranges terms_date_ranges on terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = 'Term' AND date_ranges.type = 'SchoolYear'",
    :conditions => "terms_date_ranges.active = 't'",
    :order      => "end_date DESC"
  

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
    # FIXME - Remove all "bad" attributes (empty active? checkboxes)
    term_attributes.reject!{|i| i[:name].blank?}

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