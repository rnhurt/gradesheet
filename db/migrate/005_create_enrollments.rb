class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.integer :student_id
      t.integer :course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
