#encoding: utf-8

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

    it "should not pass test for nick" do
      User.formatted_nick?('nick').should_not be
    end

    it "should pass test for @nick-_." do
      User.formatted_nick?('@nick-_.').should be
    end

    it "should pass test for @ник" do
      User.formatted_nick?('@ник').should be
    end

    it "should not pass test for @nick!" do
      User.formatted_nick?('@nick!').should_not be
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

  context "Nickname" do
    it "should fail for wrong nickname" do
      User.nickname('nick', 'wow@ya.ru').should eq('Usage: nick @nickname')
    end

    it "should create user" do
      User.nickname('@wow', 'wow@ya.ru')
      User.all.count.should eq(1)
    end

    it "should update user nickname" do
      User.create(jid: 'wow@ya.ru', nick: 'wyld')
      User.nickname('@wow', 'wow@ya.ru')

      User.first.nick.should eq('wow')
    end
  end

end
