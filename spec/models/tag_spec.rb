require 'spec_helper'

describe Tag do

  after(:each) { Tag.delete_all }

  context "Return ids" do
    it "should return one id" do
      Tag.perform_tags(['wow', 'wow']).count.should eq(1)
    end

    it "should return new ids" do
      Tag.perform_tags(['wow', 'wow2']).count.should eq(2)
    end

    it "should return empty array" do
      Tag.perform_tags([]).should eq([])
    end
  end


  context "Get privacy level" do
    it "should tell public if no tags" do
      Tag.get_privacy_level([]).should eq('public')
    end

    it "should tell public if no privacy tags" do
      Tag.get_privacy_level(['kokoko', 'ugnich']).should eq('public')
    end

    it "should tell private if private tag included" do
      Tag.get_privacy_level(['private', 'kokoko']).should eq('private')
    end
  end


  context "Clear privacy level" do
    it "should return public if only public" do
      Tag.clear_privacy_tags(['public']).first.should eq('public')
    end

    it "should return public if public is last" do
      Tag.clear_privacy_tags(['private', 'friends', 'public']).first.should eq('public')
    end

    it "should return public at first position" do
      Tag.clear_privacy_tags(['sir', 'public']).first.should eq('public')
    end

    it "should return nothing" do
      Tag.clear_privacy_tags([]).should be_empty
    end
  end


end
