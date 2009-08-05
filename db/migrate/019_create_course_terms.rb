class CreateCourseTerms < ActiveRecord::Migration
  def self.up
    create_table :course_terms do |t|
      t.integer :term_id
      t.integer :course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :course_terms
  end
end
