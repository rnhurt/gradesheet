class CreateGradations < ActiveRecord::Migration
  def self.up
    create_table :gradations do |t|
      t.integer :student_id
      t.integer :assignment_id
      t.string :points_earned

      t.timestamps
    end
    
    # Add a UNIQUE index since thier is a race condition in Rails
		add_index(:gradations, [:student_id, :assignment_id], :unique => true)
  end

  def self.down
    drop_table :gradations
  end
end
