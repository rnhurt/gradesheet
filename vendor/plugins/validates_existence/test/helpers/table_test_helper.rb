module TableTestHelper
  
  def create_all_tables
    create_blogs_table
    create_posts_table
    create_comments_table
  end
  
  def create_blogs_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :blogs do |t|
        end
      end
    end
  end
  
  def create_posts_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :posts do |t|
          t.integer  :blog_id
        end
      end
    end
  end
  
  def create_comments_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :comments do |t|
          t.integer  :commentable_id
          t.string   :commentable_type
        end
      end
    end
  end
  
  def drop_all_tables
    ActiveRecord::Base.connection.tables.each do |table|
      drop_table(table)
    end
  end
  
  def drop_table(table)
    ActiveRecord::Base.connection.drop_table(table)
  end
  
end