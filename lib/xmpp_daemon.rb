module XmppDaemon

  JID = 'rejuick-bot@jabber.ru'
  PASS = 'vfplfbot'


  def start
    bot = connect(JID, PASS)

    puts "Connected!"

    bot.send(Jabber::Presence.new.set_show(nil))

    puts "Listeninig..."

    listen(bot)
  end

  def stop
    ##bot.close
  end


  private

  def connect(jid, pass)
    begin
      bot = Jabber::Client::new(Jabber::JID::new(jid))
      bot.connect
      bot.auth(pass)
    rescue
      bot = nil
    end

    bot
  end

  def listen(bot)
    bot.add_message_callback { |msg| p parse(msg) }
  end

  def parse(msg)
    sender = msg.from.split('/')

    jid = sender[0].blank? ? '' : sender[0]
    resource = sender[1].blank? ? '' : sender[1]

    body = msg.body.blank? ? '' : msg.body

    [jid, resource, body]
  end

end

