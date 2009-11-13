class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.string  :commentable_id
      t.string  :commentable_type
      t.text    :content
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
