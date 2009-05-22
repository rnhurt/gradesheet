class CreateScaleRanges < ActiveRecord::Migration
  def self.up
    create_table :scale_ranges do |t|
      t.integer :grading_scale_id
      t.string  :description
      t.float   :max_score
      t.float   :min_score
      t.string  :letter_grade
      t.integer :position
      
      t.timestamps
    end
  end

  def self.down
    drop_table :scale_ranges
  end
end    
