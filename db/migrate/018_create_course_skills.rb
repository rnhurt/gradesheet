class CreateCourseSkills < ActiveRecord::Migration
  def self.up
    create_table :course_skills do |t|
      t.integer :course_id
      t.integer :supporting_skill_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :course_skills
  end
end
