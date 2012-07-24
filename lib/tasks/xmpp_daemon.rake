require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

include XmppDaemon

namespace :xmppd do

  task(start: :environment) do
    Client.start
  end

  task(stop: :environment) do
    Client.stop
  end

end
