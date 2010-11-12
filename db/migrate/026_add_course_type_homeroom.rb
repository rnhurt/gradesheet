class AddCourseTypeHomeroom < ActiveRecord::Migration
  def self.up
    # Add the new 'active' columns
    add_column :course_types, :is_homeroom, :boolean, :default => false
  end

  def self.down
    remove_column :course_types, :is_homeroom
  end
end
