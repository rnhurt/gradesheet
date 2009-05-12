class CreateGradingSkills < ActiveRecord::Migration
  def self.up
    create_table :grading_skills do |t|
      t.integer :course_id
      t.string  :symbol
      t.string  :description
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :grading_skills
  end
end
