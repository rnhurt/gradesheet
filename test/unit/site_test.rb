require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
	def setup
    @site = Site.new :name => "Test Site"
    assert @site.save	
	end

	def teardown
		assert @site.destroy
	end


  def test_site
    site_copy = Site.find(@site.id)
    assert_equal @site.name, site_copy.name
	end
	
	def test_site_name_length
		@site.name = "This is a really long site name that probably shouldn't be legal because it is too long"
  	assert !@site.valid?, "Site name too long" 	

		@site.name = ""
	 	assert !@site.valid?, "Site name too short" 	

		@site.name = "Site #2"
		assert @site.valid?, "Site name is just right"		
  end
end
