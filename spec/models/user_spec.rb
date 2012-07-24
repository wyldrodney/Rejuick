require 'spec_helper'

describe User do

  after(:each) { User.delete_all }

  context "Find user" do
    it "should not find user" do
      User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      User.find_user('wyld').should_not be
    end

    it "should find user" do
      User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      User.find_user('@wyld').should be_a_kind_of(User)
    end
  end

  context "Nick string format" do
    it "should pass test for @nick" do
      User.formatted_nick?('@nick').should be
    end

    it "should not pass test for @nick" do
      User.formatted_nick?('nick').should_not be
    end
  end

  context "Subscribe" do
    it "should not find user" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      user.subscribe('@mark').should eq('User not found.')
    end

    it "should find user" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      User.create(jid: 'mark@rodney.ru', nick: 'mark')
      ret = user.subscribe('@mark')
      ret.should_not eq('User not found.')
      ret.should be_a_kind_of(String)
    end
  end

  context "Whitelist" do
    it "should not find user" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      user.whitelist('@mark').should eq('User not found.')
    end

    it "should find user" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      User.create(jid: 'mark@rodney.ru', nick: 'mark')
      ret = user.whitelist('@mark')
      ret.should_not eq('User not found.')
      ret.should be_a_kind_of(String)
    end
  end

  context "Readers, writers and friends" do
    it "should return array of readers" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      user.readers.should be
    end

    it "should return array of writers" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      user.writers.should be
    end

    it "should return array of friends" do
      user = User.create(jid: 'wyld@rodney.ru', nick: 'wyld')
      user.friends.should be
    end
  end

end
