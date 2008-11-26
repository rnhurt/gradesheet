class CreateGradingScales < ActiveRecord::Migration
  def self.up
    create_table :grading_scales do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :grading_scales
  end
end
