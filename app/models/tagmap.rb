class Tagmap < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
  # attr_accessible :title, :body
end
