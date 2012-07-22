require 'spec_helper'

include XmppDaemon


describe "XmppDaemon" do

  it "should tell hello" do
    start.should eq("KOKOKO SIR!")
  end

end

