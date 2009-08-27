class SchoolYear < DateRange
  after_update :save_terms

  has_many  :terms, :dependent => :destroy

  validates_length_of		:name, :within => 1..20
  validates_associated  :terms, :message => "are not correct."

  # Return the current school year record, if there is one.
  def self.current_year
    term = Term.first
    term ? SchoolYear.first(:conditions => { "id" => term.school_year }) : []
  end
  
  named_scope :active,
    :select     => "DISTINCT date_ranges.*",
    :joins      => "INNER JOIN date_ranges terms_date_ranges on terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = 'Term' AND date_ranges.type = 'SchoolYear'",
    :conditions => "terms_date_ranges.active = 't'",
    :order      => "end_date DESC"
  

# SELECT date_ranges.* FROM date_ranges inner join date_ranges terms_date_ranges on terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = "Term" AND date_ranges.type = "SchoolYear" WHERE terms_date_ranges.active = "t";
# SELECT date_ranges.* FROM date_ranges INNER JOIN date_ranges terms_date_ranges ON terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = 'Term' WHERE terms_date_ranges.school_year_id = 'date_ranges.school_year_id' AND date_ranges.type = 'SchoolYear';
# SELECT date_ranges.* FROM date_ranges INNER JOIN date_ranges terms_date_ranges ON terms_date_ranges.school_year_id = date_ranges.id AND terms_date_ranges.type = 'Term' WHERE terms_date_ranges.school_year_id = 'date_ranges.school_year_id' AND date_ranges.type = 'SchoolYear'

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