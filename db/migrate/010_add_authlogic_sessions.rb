class AddAuthlogicSessions < ActiveRecord::Migration

  def self.up
    # Replacing :short_name column with :login
    rename_column :users, :short_name, :login

    # Add new Authlogic columns
    add_column :users,  :crypted_password,  :string
    add_column :users,  :password_salt,     :string
    add_column :users,  :persistence_token, :string
    add_column :users,  :login_count,       :integer
    add_column :users,  :last_request_at,   :datetime
    add_column :users,  :last_login_at,     :datetime
    add_column :users,  :current_login_at,  :datetime
    add_column :users,  :last_login_ip,     :string
    add_column :users,  :current_login_ip,  :string
  end
    
  def self.down
    # Restore :short_name column
    rename_column :users, :login, :short_name

    # Remove Authlogic columns
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    remove_column :users, :persistence_token
    remove_column :users, :login_count
    remove_column :users, :last_request_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_at
    remove_column :users,:last_login_ip
    remove_column :users, :current_login_ip          
  end
  
end 

      

