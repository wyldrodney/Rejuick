module XmppDaemon

  require 'xmpp4r'
  require 'xmpp4r/roster'

  JID = 'rejuick-bot@jabber.ru'
  PASS = 'vfplfbot'


  class Client

    include XmppDaemon

    @@master = nil

    def self.start
      unless self.status
        puts 'Starting.'
        new(JID, PASS)
      else
        puts 'Already running.'
      end
    end

    def self.stop
      if self.status
        @@master.close
        puts 'Closed.'
      else
        puts 'Not running.'
      end
    end

    def self.status
      @@master and @@master.is_connected?
    end


    def initialize(jid, pass)
      @bot = connect(jid, pass)

      if @bot
        @@master = @bot

        @bot.send(Jabber::Presence.new.set_type(:available))
        listen(@bot)
      else
        raise 'Can\'t connect.'
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
      roster = Jabber::Roster::Helper.new(bot)

      roster.add_subscription_request_callback do |item, ask|
        roster.accept_subscription(ask.from)
        @bot.send(Jabber::Presence.new.set_type(:subscribe).set_to(ask.from))
      end

      bot.add_message_callback do |msg|
        answer = workout parse(msg)
        send_message answer[0], answer[1]
      end
    end

    def send_message(jid, body)
      message = Jabber::Message::new(jid, body)
      message.set_type(:chat)

      @bot.send message
    end

  end



  def parse(msg)
    sender = msg.from.blank? ? [] : msg.from.to_s.split('/')

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

    msg = if %w( help nick ping about lang wl ).include? body.downcase
      case body.downcase
      when 'help'
        'Help: nick (set registartion), about (set your info), lang (set your lang). Gonna play ping-pong?'
      when 'nick'
        'Usage: nick @nickname'
      when 'ping'
        'Pong'
      when 'about'
        'User.about()...'
      when 'wl'
        'User.whitelist()...'
      end
    else
      if body =~ /nick @/i
        User.nickname("@#{body.split('@')[1]}", jid)
      else
        body.reverse
      end
    end

    [jid, msg]
  end

end

