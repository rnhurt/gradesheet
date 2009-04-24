require File.dirname(__FILE__) + '/init'


# Blog

  class Blog < ActiveRecord::Base
    has_many :posts
  end

# Post

  class Post < ActiveRecord::Base
    belongs_to :blog
    has_many :comments, :as => :commentable
  end

  class PostWithRequiredBlog < Post
    validates_existence_of :blog
  end

  class PostWithoutRequiredBlog < Post
    validates_existence_of :blog, :allow_nil => true
  end
  
  class PostWithRequiredBlogIf < Post
    validates_existence_of :blog, :if => :condition
    attr_accessor :condition
  end
  
  class PostWithRequiredBlogUnless < Post
    validates_existence_of :blog, :unless => :condition
    attr_accessor :condition
  end

# Comment

  class Comment < ActiveRecord::Base
    belongs_to :commentable, :polymorphic => true
  end

  class CommentWithRequiredCommentable < Comment
    validates_existence_of :commentable
  end

  class CommentWithoutRequiredCommentable < Comment
    validates_existence_of :commentable, :allow_nil => true
  end


class ValidatesExistenceTest < Test::Unit::TestCase
  
  def setup
    create_all_tables
    @default_blog = Blog.create
    @default_post = PostWithoutRequiredBlog.create
  end
  
  def teardown
    drop_all_tables
  end
  
  # PostWithRequiredBlog
  
    def test_should_create_post_with_required_blog_with_valid_blog
      @post = PostWithRequiredBlog.new :blog_id => @default_blog.id
      assert @post.save
    end
  
    def test_should_not_create_post_with_required_blog_when_blog_is_nil
      @post = PostWithRequiredBlog.new
      assert !@post.save
      assert @post.errors.on(:blog)
    end
  
    def test_should_not_create_post_with_required_blog_when_blog_does_not_exist
      @post = PostWithRequiredBlog.new :blog_id => '2'
      assert !@post.save
      assert @post.errors.on(:blog)
    end
  
  # PostWithoutRequiredBlog
  
    def test_should_create_post_without_required_blog_with_valid_blog
      @post = PostWithoutRequiredBlog.new :blog_id => @default_blog.id
      assert @post.save
    end
  
    def test_should_create_post_without_required_blog_when_blog_is_nil
      @post = PostWithoutRequiredBlog.new
      assert @post.save
    end
  
    def test_should_not_create_post_without_required_blog_when_blog_does_not_exist
      @post = PostWithoutRequiredBlog.new :blog_id => '2'
      assert !@post.save
      assert @post.errors.on(:blog)
    end
    
  # Polymorphic CommentWithRequiredCommentable
  
    def test_should_create_comment_with_required_commentable_with_valid_commentable
      @comment = CommentWithRequiredCommentable.new :commentable_id => @default_post.id, :commentable_type => 'Post'
      assert @comment.save
    end
  
    def test_should_not_create_comment_with_required_commentable_when_commentable_is_nil
      @comment = CommentWithRequiredCommentable.new
      assert !@comment.save
      assert @comment.errors.on(:commentable)
    end
  
    def test_should_not_create_comment_with_required_commentable_when_commentable_does_not_exist
      @comment = CommentWithRequiredCommentable.new :commentable_id => '2', :commentable_type => 'Post'
      assert !@comment.save
      assert @comment.errors.on(:commentable)
    end
    
  # Polymorphic CommentWithoutRequiredCommentable
  
    def test_should_create_comment_without_required_commentable_with_valid_commentable
      @comment = CommentWithoutRequiredCommentable.new :commentable_id => @default_post.id, :commentable_type => 'Post'
      assert @comment.save
    end
  
    def test_should_create_comment_without_required_commentable_when_commentable_is_nil
      @comment = CommentWithoutRequiredCommentable.new
      assert @comment.save
    end
  
    def test_should_not_create_comment_without_required_commentable_when_commentable_does_not_exist
      @comment = CommentWithoutRequiredCommentable.new :commentable_id => '2', :commentable_type => 'Post'
      assert !@comment.save
      assert @comment.errors.on(:commentable)
    end
    
  # PostWithRequiredBlogIf (:if => :condition)
  
    def test_post_should_require_blog_when_if_condition_is_true
      @post = PostWithRequiredBlogIf.new
      @post.condition = true
      assert !@post.save
    end
    
    def test_post_should_not_require_blog_when_if_condition_is_false
      @post = PostWithRequiredBlogIf.new
      @post.condition = false
      assert @post.save
    end
    
  # PostWithRequiredBlogUnless (:unless => :condition)

    def test_post_should_require_blog_when_unless_condition_is_false
      @post = PostWithRequiredBlogUnless.new
      @post.condition = false
      assert !@post.save
    end
    
    def test_post_should_not_require_blog_when_unless_condition_is_true
      @post = PostWithRequiredBlogUnless.new
      @post.condition = true
      assert @post.save
    end
  
end