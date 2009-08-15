class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.string    :name
      t.integer   :course_term_id
      t.integer   :assignment_category_id
      t.float     :possible_points
      t.timestamp	:due_date

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
