class AddCourseTypes < ActiveRecord::Migration
  def self.up
    create_table :course_types do |t|
      t.string  :name
      t.integer :position
      t.boolean :active,  :default => true

      t.timestamps
    end

    add_column :courses, :course_type_id, :integer

  end

  def self.down
    drop_table :course_types
    remove_column :courses, :course_type_id
  end
end
