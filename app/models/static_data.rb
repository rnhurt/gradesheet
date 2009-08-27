# This class handles all the static data in the application.  It allows us to
# efficiently use the same data in different parts of the application and persist
# it to the database as needed.
class StaticData < ActiveRecord::Base
  # Rename the database table
  def self.table_name() 'static_data' end

  validates_length_of :value, :in => 1..40


  # SITE_NAME  
  def self.site_name
    return lookup('SITE_NAME')
  end

  # TAG_LINE
  def self.tag_line 
    return lookup('TAG_LINE')
  end

  
  private
  # Get the static value from the database
  def self.lookup(name)
    StaticData.find_by_name(name).value
  end
  
end

