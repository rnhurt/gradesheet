class CreateAssignmentCategories < ActiveRecord::Migration
  def self.up
    create_table :assignment_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_categories
  end
end
