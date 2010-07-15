class AddActiveFlags < ActiveRecord::Migration
  def self.up
    add_column :users,        :active, :boolean, :default => true
    add_column :assignments,  :active, :boolean, :default => true
    add_column :assignment_categories,  :active, :boolean, :default => true
    add_column :sites,        :active, :boolean, :default => true
  end

  def self.down
    remove_column :users,       :active
    remove_column :assignments, :active
    remove_column :assignment_categories, :active
    remove_column :sites,       :active
  end
end
