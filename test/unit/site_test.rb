require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_site
    
    test_site = Site.new :name => "NDA"
    assert test_site.save
    
    test_site_copy = Site.find(test_site.id)
    assert_equal test_site.name, test_site_copy.name

		assert test_site.destroy
	end
	
	def test_site_name_length
		site = Site.new :name => "This is a really long site name that probably shouldn't be legal because it is too long"
  	assert !site.valid?, "Site name too long" 	

		site.name = ""
	 	assert !site.valid?, "Site name too short" 	
		
		assert site.destroy
  end
end
