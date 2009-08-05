class CreateSupportingSkills < ActiveRecord::Migration
  def self.up
    create_table :supporting_skills do |t|
      t.integer :course_term_id
      t.integer :supporting_skill_category_id
      t.string  :description
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_skills
  end
end
