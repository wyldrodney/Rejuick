class User < ActiveRecord::Base

  attr_accessible :about, :confirm_subs, :jid, :lang, :nick

  validates_presence_of :jid, :nick
  validates_uniqueness_of :jid, :nick


  def self.find_user(arg)
    user = if formatted_nick?(arg)
      ## If argument is String and looks like @nickname, then...

      User.find_by_nick(arg[1..-1])
    else
      ## Here we'll put other type of search (by link?)...

      nil
    end
  end

  def self.formatted_nick?(arg)
    arg.kind_of?(String) && arg =~ /^@[ a-z \u0430-\u044f \u0451 \. \- \_ ]+$/i

    ## English + Russian chars + symbols: minus, dot and underline
  end

  def self.nickname(name, jid)
    return 'Usage: nick @nickname' unless formatted_nick?(name)

    user = User.find_by_jid(jid)

    if user
      user.update_attributes(nick: name[1..-1]) ? 'Nick updated!' : 'Nick already in use!'
    else
      User.create(nick: name[1..-1], jid: jid)
      'User created!'
    end
  end

  def subscribe(arg)
    writer = User.find_user(arg)

    writer ? Subscription.subscribe(self.id, writer.id, writer.confirm_subs) : 'User not found.'
  end

  def whitelist(arg)
    reader = User.find_user(arg)

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
