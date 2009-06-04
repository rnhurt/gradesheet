class CreateSupportingSkillCodes < ActiveRecord::Migration
  def self.up
    create_table :supporting_skill_codes do |t|
      t.integer :supporting_skill_id
      t.string :code
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_skill_codes
  end
end
