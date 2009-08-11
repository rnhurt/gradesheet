require File.dirname(__FILE__) + '/../test_helper'

class SitesTest < ActionController::IntegrationTest
  def setup
    # Login as an administrator
    post "/user_sessions", :user_session => {:login => "admin", :password => "admin"}
    #    Rails.logger.info session.inspect
    assert_equal 'Login successful!', flash[:notice]

    @site = Site
  end

  def test_add_site
    # Create a new site
    post "/settings/sites", :site => {:name => "BlahBlah"}
    assert_response :redirect
    follow_redirect!
    assert_template "index"

    # Verify the site exists
    @site = Site.find_by_name("BlahBlah")
    assert_equal "BlahBlah", @site.name
  end

  def test_delete_site
    # Remove the site you just added
    delete "/settings/sites/#{@site.id}"
    assert_response :redirect
    follow_redirect!
    assert_template "index"

    # Verify the category has been deleted
    assert_raise(ActiveRecord::RecordNotFound) {
      Site.find(@site.id)
    }
  end
end