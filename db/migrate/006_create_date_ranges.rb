class CreateDateRanges < ActiveRecord::Migration
  def self.up
    create_table :date_ranges do |t|
      t.string  :type
      t.string	:name
      t.string	:description
      t.date		:begin_date, :end_date
      t.integer :school_year_id
      t.boolean	:active
      
      t.timestamps
    end
  end

  def self.down
    drop_table :date_ranges
  end
end
