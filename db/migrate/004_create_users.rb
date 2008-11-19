class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    	t.string :type
      t.integer :site_id
      t.string :short_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :class_of

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
