class Comment < ActiveRecord::Base
  belongs_to  :commentable, :polymorphic => true

  named_scope :active, :conditions => {:active => true}
  named_scope :quick, :conditions =>
    {:commentable_type => 'QuickComment'}
end
