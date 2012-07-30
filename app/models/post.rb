class Post < ActiveRecord::Base
  belongs_to :user

  has_many :tagmaps
  has_many :tags, :through => :tagmaps

  attr_accessible :body
end
