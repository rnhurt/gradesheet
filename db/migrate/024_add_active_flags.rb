class AddActiveFlags < ActiveRecord::Migration
  def self.up
    # Add the new 'active' columns
    add_column :users,        :active, :boolean, :default => true
    add_column :assignments,  :active, :boolean, :default => true
    add_column :assignment_categories,  :active, :boolean, :default => true
    add_column :sites,        :active, :boolean, :default => true

    # Make everything active!
    execute "UPDATE users SET active = 't';"
    execute "UPDATE assignments SET active = 't';"
    execute "UPDATE assignment_categories SET active = 't';"
    execute "UPDATE sites SET active = 't';"
  end

  def self.down
    remove_column :users,       :active
    remove_column :assignments, :active
    remove_column :assignment_categories, :active
    remove_column :sites,       :active
  end
end
