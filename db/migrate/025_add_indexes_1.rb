class AddIndexes1 < ActiveRecord::Migration
  def self.up
    add_index :assignments, [:course_term_id]
    add_index :assignment_evaluations, [:student_id]
    add_index :assignment_evaluations, [:assignment_id]

    # Update an index to include 'class_of'
		remove_index :users, [:first_name, :last_name]
		add_index :users, [:first_name, :last_name, :class_of], :unique => true

  end

  def self.down
    remove_index :assignments, [:course_term_id]
    remove_index :assignment_evaluations, [:student_id]
    remove_index :assignment_evaluations, [:assignment_id]

    # Update an index to remove 'class_of'
 		remove_index :users, [:first_name, :last_name, :class_of]
		add_index :users, [:first_name, :last_name], :unique => true
  end
end
