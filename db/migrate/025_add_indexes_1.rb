class AddIndexes1 < ActiveRecord::Migration
  def self.up
    add_index :assignments, [:course_term_id]
    add_index :assignment_evaluations, [:student_id]
    add_index :assignment_evaluations, [:assignment_id]
  end

  def self.down
    remove_index :assignments, [:course_term_id]
    remove_index :assignment_evaluations, [:student_id]
    remove_index :assignment_evaluations, [:assignment_id]
  end
end
