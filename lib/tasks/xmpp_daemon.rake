require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

require 'xmpp4r'

include XmppDaemon


namespace :xmppd do

  task(start: :environment) do
    start
  end

end
