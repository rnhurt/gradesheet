class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.integer :teacher_id
      t.integer :term_id
      t.integer :grade_scale_id
      t.integer :course_att_id
      t.integer :course_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
