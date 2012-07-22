require 'spec_helper'

include XmppDaemon


describe "XmppDaemon" do

  let(:jid) { 'rejuick-bot@jabber.ru' }
  let(:pass) { 'vfplfbot' }


  it "should connect to server" do
    connect(jid, pass).should be
  end

  it "should not connect to server" do
    connect(jid, 'wrong').should_not be
  end

end

