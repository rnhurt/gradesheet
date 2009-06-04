class CreateSupportingSkillEvaluations < ActiveRecord::Migration
  def self.up
    create_table :supporting_skill_evaluations do |t|
      t.integer :student_id
      t.integer :supporting_skill_id
      t.integer :supporting_skill_code_id

      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_skill_evaluations
  end
end
