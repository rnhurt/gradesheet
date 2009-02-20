class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
    	t.string	:school_year
      t.string	:name
      t.date		:begin_date, :end_date
      t.boolean	:active
      
			t.integer	:courses_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
