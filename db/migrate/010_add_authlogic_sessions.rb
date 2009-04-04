class AddAuthlogicSessions < ActiveRecord::Migration

  def self.up
    # Replacing :short_name column with :login
    rename_column :users, :short_name,  :login
    execute "UPDATE users SET login = 'INVALID';"
    change_column :users, :login,       :string,  :null => false

    # Add new Authlogic columns
    add_column :users,  :crypted_password,    :string
    add_column :users,  :password_salt,       :string
    add_column :users,  :persistence_token,   :string
    add_column :users,  :single_access_token, :string
    add_column :users,  :perishable_token,    :string

    # Put something in the columns so that we can add the NOT-NULL clause
    execute "UPDATE users SET 
                crypted_password    = 'INVALID', 
                password_salt       = 'INVALID',
                persistence_token   = 'INVALID',
                single_access_token = 'INVALID',
                perishable_token    = 'INVALID';"

    # Disallow null for these columns
    change_column :users,  :crypted_password,   :string,  :null => false
    change_column :users,  :password_salt,      :string,  :null => false
    change_column :users,  :persistence_token,  :string,  :null => false
    change_column :users,  :single_access_token,:string,  :null => false
    change_column :users,  :perishable_token,   :string,  :null => false

    # Add all the 'normal' columns
    add_column :users,  :login_count,         :integer, :null => false, :default => 0
    add_column :users,  :failed_login_count,  :integer, :null => false, :default => 0
    add_column :users,  :last_request_at,     :datetime
    add_column :users,  :current_login_at,    :datetime
    add_column :users,  :last_login_at,       :datetime
    add_column :users,  :current_login_ip,    :string
    add_column :users,  :last_login_ip,       :string
  end
    
  def self.down
    # Restore :short_name column
    rename_column :users, :login, :short_name

    # Remove Authlogic columns
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    remove_column :users, :persistence_token
    remove_column :users, :single_access_token
    remove_column :users, :perishable_token
    remove_column :users, :login_count
    remove_column :users, :failed_login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip          
    remove_column :users, :last_login_ip
  end
  
end 

      

