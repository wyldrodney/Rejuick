#encoding: utf-8

require 'spec_helper'

describe Post do

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


  context "Get privacy level" do
    it "should tell public if no tags" do
      Post.get_privacy_level([]).should eq('public')
    end

    it "should tell public if no privacy tags" do
      Post.get_privacy_level(['kokoko', 'ugnich']).should eq('public')
    end

    it "should tell private if private tag included" do
      Post.get_privacy_level(['kokoko', 'private']).should eq('private')
    end
  end
end
