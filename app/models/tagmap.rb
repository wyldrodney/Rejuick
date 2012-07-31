class Tagmap < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag

  attr_accessible :tag_id, :post_id


  def self.perform_tagmaps(tags, post)
    ## Create new list of post tags.

    post.tags.delete_all

    tags.each { |tag_id| Tagmap.create(post_id: post.id, tag_id: tag_id) }
  end

end
