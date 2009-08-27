require File.dirname(__FILE__) + '/../test_helper'

class SitesTest < ActionController::IntegrationTest
  def setup
    visit root_path
    click_link "log in"
    fill_in "login", :with => "admin"
    fill_in "password", :with => "admin"
    click_button "Login"
    assert_contain "Login successful!"

    @site = Site
  end

  test "add and delete a new site" do
    # Create a new site
    visit sites_path
    click_link "Add Site"
    assert_contain "Name"
    fill_in "name", :with => "New Campus"
    click_button "Save"
    assert_contain "Campus 'New Campus' was successfully created."

    # Verify the site exists
    @site = Site.find_by_name("New Campus")
    assert_equal "New Campus", @site.name

    # Remove the site you just added
    visit sites_path
    assert_contain "New Campus"

    click_button @site.id
    assert_contain "Campus '#{@site.name}' was successfully deleted."

    # Verify the site has been deleted
    assert_raise(ActiveRecord::RecordNotFound) {
      Site.find(@site.id)
    }
  end

  test "delete an existing site with users" do
    # Find an existing site
    visit sites_path
    @site = Site.first
    assert_valid @site

    # Try to remove it
    assert_raise(Webrat::DisabledFieldError) {
      click_button @site.id
    }
    assert_not_contain "Campus '#{@site.name}' was successfully deleted."

    # Verify the site has not been deleted
    site = Site.find(@site.id)
    assert_valid site
  end

  test "update an existing site" do
    # Find an existing site
    visit sites_path
    @site = Site.first
    assert_valid @site

    # Edit its name
    click_link @site.name
    fill_in "name", :with => "New Name"
    click_button "Save"

    # Check to make sure it saved properly
    assert_contain "Campus 'New Name' was successfully updated."
    site = Site.find(@site.id)
    assert_equal "New Name", site.name
  end
end