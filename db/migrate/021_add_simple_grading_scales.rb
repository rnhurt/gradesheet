class AddSimpleGradingScales < ActiveRecord::Migration
  def self.up
    add_column :grading_scales, :simple_view, :boolean, :default => false
  end

  def self.down
    remove_column :grading_scales,  :simple_view
  end
end
