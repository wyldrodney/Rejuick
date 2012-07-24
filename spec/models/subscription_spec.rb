require 'spec_helper'

describe Subscription do

  after(:each) { Subscription.delete_all }

  context "Find pair" do
    it "should not find pair" do
      Subscription.find_pair(2, 1).should_not be
    end

    it "should find pair" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.find_pair(2, 1).should be_a_kind_of(Subscription)
    end
  end

  context "Whitelist" do
    it "should ignore confirmation" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.whitelist(1, 2, true)
      Subscription.first.confirm.should eq(true)
    end

    it "should set confirmation to true" do
      Subscription.create(writer: 1, reader: 2, confirm: false)
      Subscription.whitelist(1, 2, false)
      Subscription.first.confirm.should eq(true)
    end

    it "should set confirmation to false" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.whitelist(1, 2, false)
      Subscription.first.confirm.should eq(false)
    end
  end

  context "Subscribe" do
    it "should do nothing if subscription exists" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.subscribe(2, 1, false) ## or true as last argument
      Subscription.all.count.should eq(1)
    end

    it "should create record if subscription doesn't exists" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.subscribe(2, 3, true) ## or false as last argument
      Subscription.all.count.should eq(2)
    end
  end

  context "Readers, writers and friends" do
    it "should find reader for writer and return array" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.readers(1)[0].reader.should eq(2)
    end

    it "should find writer for reader and return array" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.writers(2)[0].writer.should eq(1)
    end

    it "should find friends and return array's intersection" do
      Subscription.create(writer: 1, reader: 2, confirm: true)
      Subscription.create(writer: 2, reader: 1, confirm: true)
      Subscription.friends(1)[0].should eq(2)
    end
  end

end
