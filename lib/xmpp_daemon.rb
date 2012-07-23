module XmppDaemon

  JID = 'rejuick-bot@jabber.ru'
  PASS = 'vfplfbot'


  class Client

    @@master = nil

    def self.start
      if @@master.is_disconnected?
        puts 'Starting.'
        new(JID, PASS)
      else
        puts 'Already running.'
      end
    end

    def self.stop
      if @@master.is_connected?
        @@master.close
        puts "Closed."
      else
        puts "Not running."
      end
    end

    def self.status
      @@master.is_connected?
    end


    def initialize(jid, pass)
      @bot = connect(jid, pass)

      if @bot
        @@master = @bot

        @bot.send(Jabber::Presence.new.set_show(nil))
        listen(@bot)
      else
        raise "Can't connect."
      end
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
      bot.add_message_callback { |msg| workout parse(msg) }
    end

    def send(jid, body)
      message = Jabber::Message::new(jid, body)
      message.set_type(:chat)

      @bot.send message
    end

  end



  def parse(msg)
    sender = msg.from.blank? ? [] : msg.from.split('/')

    jid = sender[0] || ''
    resource = sender[1] || ''
    body = msg.body || ''

    [jid, resource, body]
  end

  def workout(msg)
    jid = msg[0]
    resource = msg[1]
    body = msg[2]

    return nil if jid.empty? or body.empty?

    if %w( HELP HELPFULL NICK LOGIN PING ).include? body.upcase
      case body.upcase
      when 'HELP'
        send(jid, 'HELP? Didn\'t hear. Gonna play ping-pong?')
      when 'PING'
        send(jid, 'PONG')
      else
        send(jid, 'I know that word. And what?')
      end
    else
      send(jid, "#{jid}: #{body}")
    end
  end

end

