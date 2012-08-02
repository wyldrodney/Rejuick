require 'spec_helper'

describe Receiver do

  before(:each) do
    @bob = stub(User)
    @bob.stub(:id).and_return(1)
    @bob.stub(:jid).and_return(nil)

    @john = stub(User)
    @john.stub(:id).and_return(2)
    @john.stub(:jid).and_return(nil)

    @rod = stub(User)
    @rod.stub(:readers).and_return([@bob, @john])

    @rec = stub(Receiver)
    @rec.stub(:delete_all).and_return(nil)

    @post = stub(Post)
    @post.stub(:id).and_return(1)
    @post.stub(:user_id).and_return(1)
    @post.stub(:receivers).and_return(@rec)
    @post.stub(:to_message).and_return(nil)
  end

  after(:each) { Receiver.delete_all }


  context "Perform receivers" do
    it "should create two records on public" do
      Receiver.perform_receivers(@post, @rod, 'public')
      Receiver.count.should eq(2)
    end

    it "should create two records on readers" do
      Receiver.perform_receivers(@post, @rod, 'readers')
      Receiver.count.should eq(2)
    end

    it "should not create any records" do
      Receiver.perform_receivers(@post, @rod, 'private')
      Receiver.count.should eq(0)
    end
  end


  context "User can read post?" do
    it "should return true if receiver" do
      Receiver.create(user_id: @bob.id, post_id: @post.id)
      Receiver.can_read?(@bob, @post).should be
    end

    it "should return true if owner" do
      Receiver.create(user_id: @bob.id, post_id: @post.id)
      Receiver.can_read?(@bob, @post).should be
    end

    it "should not return true" do
      Receiver.create(user_id: @bob.id, post_id: @post.id)
      Receiver.can_read?(@john, @post).should_not be
    end
  end

end
