# This class handles all the static data in the application.  It allows us to
# efficiently use the same data in different parts of the application and persist
# it to the database as needed.
class StaticData < ActiveRecord::Base
  # Rename the database table
  def self.table_name() 'static_data' end

  # SITE_NAME  
  def self.site_name
    @site_name ||= lookup('SITE_NAME') 
  end
  def self.site_name=(value)
    update('SITE_NAME', value)
    @site_name = value
  end

  # TAG_LINE
  def self.tag_line 
    @tag_line ||= lookup('TAG_LINE') 
  end
  def self.tag_line=(value) 
    update('TAG_LINE', value)
    @tag_line = value
  end

  
private
  # Get the static value from the database
  # FIXME: This could probably be updated so that it doesn't hit the DB every
  # time a lookup is performed.
  def self.lookup(name)
    StaticData.find_by_name(name).value
  end
  
  # Update the database with the new static value
  def self.update(name, val)
    temp = StaticData.find_or_create_by_name(name)
    temp.value = val
    temp.save!
  end
  
end

