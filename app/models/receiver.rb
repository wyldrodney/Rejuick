class Receiver < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  attr_accessible :user_id, :post_id


  def self.perform_receivers(post, user, privacy)
    ## Create new list of post receivers.
    ## *public and *readers => user.readers

    post.receivers.delete_all

    unless privacy == 'private'
      user.readers.each do |reader|
        Receiver.create(user_id: reader.id, post_id: post.id)
      end
    end
  end

end
