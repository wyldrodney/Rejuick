#encoding: utf-8

require 'spec_helper'

describe Post do

  after(:each) do
    Post.delete_all
    User.delete_all
  end


  context "Get tags and body" do
    it "should return two tags" do
      Post.get_tags_and_body('*hello *kitty Kiss me')[0].count.should eq(2)
    end

    it "should return two tags" do
      Post.get_tags_and_body('*hello *kitty-мясорубка Kiss me')[0].count.should eq(2)
    end

    it "should return two tags with newline" do
      Post.get_tags_and_body("*hello *kitty-мясорубка\nKiss me")[0].count.should eq(2)
    end

    it "should return body" do
      Post.get_tags_and_body('*hello *kitty Kiss me')[1].should eq('Kiss me')
    end

    it "should return body" do
      Post.get_tags_and_body("*hello *kitty-мясорубка\nKiss me")[1].should eq('Kiss me')
    end

    it "should return nil if body is blank" do
      Post.get_tags_and_body("*hello *kitty-мясорубка\n").should_not be
    end

    it "should return no tags" do
      result = Post.get_tags_and_body('kokoko, sir')
      result[0].should eq([])
      result[1].should eq('kokoko, sir')
    end
  end


  context "Create post" do
    it "should tell that user not found" do
      Post.create_post('text', "#{rand(9999..99999)}@ya.ru").should eq('You aren\'t registered. See: nick.')
    end

    it "should tell that body is empty" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.create_post('', 'test@ya.ru').should eq('Message body can\'t be empty.')
    end

    it "should tell that post saved" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.create_post('text', 'test@ya.ru').should =~ /Post #\d+ saved/
    end
  end


  context "Display message" do
    it "should be equal to original (without privacy tags and with newline sign)" do
      msg = "*pussy\nGo-go-go!"

      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.create_post(msg, 'test@ya.ru')

      Post.last.to_message.should be_include(msg)
    end
  end


  context "Read post" do
    it "should tell that user not found" do
      Post.read_post('#111', "#{rand(9999..99999)}@ya.ru").should eq('You aren\'t registered. See: nick.')
    end

    it "should tell that post not found" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.read_post('#111', 'test@ya.ru').should eq('Post not found.')
    end

    it "should allow to read my own post" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.create_post('text', 'test@ya.ru')
      post_id = Post.last.id

      Post.read_post("##{post_id}", 'test@ya.ru').should_not eq('You aren\'t allowed to read this post.')
    end

    it "should not allow to read post" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      User.create(jid: 'test2@ya.ru', nick: 'test2')
      Post.create_post('text', 'test@ya.ru')
      post_id = Post.last.id

      Post.read_post("##{post_id}", 'test2@ya.ru').should eq('You aren\'t allowed to read this post.')
    end

    it "should tell that post number is wrong" do
      User.create(jid: 'test@ya.ru', nick: 'test')
      Post.read_post('##111', 'test@ya.ru').should eq('Usage: #12345')
    end
  end
end
