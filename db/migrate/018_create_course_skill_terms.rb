class CreateCourseSkillTerms < ActiveRecord::Migration
  def self.up
    create_table :course_skill_terms do |t|
      t.integer :course_term_id
      t.integer :supporting_skill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :course_skill_terms
  end
end
