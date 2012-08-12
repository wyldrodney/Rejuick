class Receiver < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  attr_accessible :user_id, :post_id


  def self.perform_receivers(post, user, privacy, send=true)
    ## Create new list of post receivers.
    ## *public and *readers => user.readers

    post.receivers.delete_all

    unless privacy == 'private'
      ## Get receivers' jids.

      jids = user.readers.map do |reader|
        Receiver.create(user_id: reader.id, post_id: post.id)
        reader.jid
      end

      ## Disable DelayedJob's delay...
      ## Send if send arg is true (false used for new subscribers).

      Receiver.xmpp_send(jids, post.to_message) unless jids.empty? or send.nil?
    end
  end

  def self.xmpp_send(jids, body)
    jids.each { |jid| XmppDaemon::Client.message(jid, body) }
  end


  def self.can_read?(user, post)
    ## If reader is post owner or
    ## is in receivers list, then return true

    if post.user_id == user.id
      true
    elsif !(Receiver.where(post_id: post.id, user_id: user.id).empty?)
      true
    else
     false
    end
  end

end
