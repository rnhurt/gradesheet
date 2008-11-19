class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string :name
      t.date :begin_date, :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
