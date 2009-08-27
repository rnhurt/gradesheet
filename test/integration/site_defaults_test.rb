require File.dirname(__FILE__) + '/../test_helper'

class SiteDefaultsTest < ActionController::IntegrationTest
  def setup
    visit root_path
    click_link "log in"
    fill_in "login", :with => "admin"
    fill_in "password", :with => "admin"
    click_button "Login"
    assert_contain "Login successful!"
  end

  # Test the SITE NAME
  test "change the site name" do
    visit site_defaults_path
    fill_in "site_name", :with => "Your School Rocks!"
    click_button "change_site_name"
    assert_contain "Site name changed to 'Your School Rocks!'"
  end

  test "change the site name to a blank value" do
    visit site_defaults_path
    fill_in "site_name", :with => ""
    click_button "change_site_name"
    assert_contain "Failed to update site name to ''!"
  end

  test "change the site name to a very long value" do
    visit site_defaults_path
    fill_in "site_name", :with => "This is a very long value which should not be valid in this field"
    click_button "change_site_name"
    assert_contain "Failed to update site name to 'This is a very long value which should not be valid in this field'!"
  end

  # Test the TAG LINE
  test "change the tag line" do
    visit site_defaults_path
    fill_in "tag_line", :with => "Your School Rocks!"
    click_button "change_tag_line"
    assert_contain "Tag line changed to 'Your School Rocks!'"
  end

  test "change the tag line to a blank value" do
    visit site_defaults_path
    fill_in "tag_line", :with => ""
    click_button "change_tag_line"
    assert_contain "Failed to update tag line to ''!"
  end

  test "change the tag line to a very long value" do
    visit site_defaults_path
    fill_in "tag_line", :with => "This is a very long value which should not be valid in this field"
    click_button "change_tag_line"
    assert_contain "Failed to update tag line to 'This is a very long value which should not be valid in this field'!"
  end
end
