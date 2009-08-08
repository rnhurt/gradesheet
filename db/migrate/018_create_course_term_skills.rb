class CreateCourseTermSkills < ActiveRecord::Migration
  def self.up
    create_table :course_term_skills do |t|
      t.integer :course_term_id
      t.integer :supporting_skill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :course_term_skills
  end
end
