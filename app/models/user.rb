class User < ActiveRecord::Base

  attr_accessible :about, :confirm_subs, :jid, :lang, :nick

  validates_presence_of :jid, :nick
  validates_uniqueness_of :jid, :nick


  def subscribe(nick)
    writer = User.find_by_nick(nick)

    writer ? Subscription.subscribe(self.id, writer.id, writer.confirm_subs) : 'User not found.'
  end

  def whitelist(nick)
    reader = User.find_by_nick(nick)

    reader ? Subscription.whitelist(self.id, reader.id, self.confirm_subs) : 'User not found.'
  end

  def readers
    User.where(id: Subscription.readers(self.id))
  end

  def writers
    User.where(id: Subscription.writers(self.id))
  end

  def friends
    User.where(id: Subscription.friends(self.id))
  end

end
