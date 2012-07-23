require 'spec_helper'

include XmppDaemon


describe "XmppDaemon" do

  let(:jid) { 'rejuick-bot@jabber.ru' }
  let(:pass) { 'vfplfbot' }

  let(:blend_jid_msg) do
    msg = stub("Msg")
    msg.stub(:from).and_return('wyldrodney@headcounter.org/e6d74754')
    msg.stub(:body).and_return('dsfohd')
    msg
  end

  let(:clean_jid_msg) do 
    msg = stub("Msg")
    msg.stub(:from).and_return('wyldrodney@headcounter.org')
    msg.stub(:body).and_return('dsfohd')
    msg
  end

  let(:blank_body_msg) do
    msg = stub("Msg")
    msg.stub(:from).and_return('wyldrodney@headcounter.org/e6d74754')
    msg.stub(:body).and_return('')
    msg
  end

  let(:nil_body_msg) do
    msg = stub("Msg")
    msg.stub(:from).and_return('wyldrodney@headcounter.org/e6d74754')
    msg.stub(:body).and_return(nil)
    msg
  end


  context 'Connect' do
    it "should connect to server" do
      #pending
      Client.new(jid, pass).should be
    end

    it "should not connect to server" do
      #pending
      expect { Client.new(jid, 'wrong') }.to raise_error
    end
  end


  context "Start and stop" do
    it "should start" do
      pending
      Client.start
      Client.status.should be
    end

    it "should stop" do
      pending
      Client.start
      Client.stop
      Client.status.should_not be
    end
  end


  context 'Parse' do
    it "should parse blend jids" do
      parse(blend_jid_msg).should eq(['wyldrodney@headcounter.org', 'e6d74754', 'dsfohd'])
    end

    it "should parse clean jids" do
      parse(clean_jid_msg).should eq(['wyldrodney@headcounter.org', '', 'dsfohd'])
    end

    it "should parse blank body" do
      parse(blank_body_msg).should eq(['wyldrodney@headcounter.org', 'e6d74754', ''])
    end

    it "should parse nil body" do
      parse(nil_body_msg).should eq(['wyldrodney@headcounter.org', 'e6d74754', ''])
    end
  end

end

