class CreateAssignmentEvaluations < ActiveRecord::Migration
  def self.up
    create_table :assignment_evaluations do |t|
      t.integer :student_id
      t.integer :assignment_id
      t.string :points_earned

      t.timestamps
    end
    
    # Add a UNIQUE index since there is a possible race condition here
    add_index(:assignment_evaluations, [:student_id, :assignment_id], :unique => true)
  end

  def self.down
    drop_table :assignment_evaluations
  end
end
