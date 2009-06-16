class CreateSupportingSkillCategories < ActiveRecord::Migration
  def self.up
    create_table :supporting_skill_categories do |t|
      t.string  :name
      t.boolean :active, :default => true
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_skill_catetories
  end
end
