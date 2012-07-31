class Receiver < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  attr_accessible :user_id, :post_id


  def self.perform_receivers(post, user, privacy)
    ## Create new list of post receivers.
    ## *public and *readers => user.readers

    post.receivers.delete_all

    unless privacy == 'private'
      ## Get receivers' jids.

      jids = user.readers.each do |reader|
        Receiver.create(user_id: reader.id, post_id: post.id)
        reader.jid
      end

      ## Tell DelayedJob to send all messages later.

      Receiver.delay.xmpp_send(jids, post.to_message) unless jids.empty?
    end
  end

  def self.xmpp_send(jids, body)
    jids.each { |jid| XmppDaemon::Client.message(jid, body) }
  end

end
