class Tag < ActiveRecord::Base
  has_many :tagmaps
  has_many :posts, :through => :tagmaps

  attr_accessible :name
end
