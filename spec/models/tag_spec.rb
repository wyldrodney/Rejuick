require 'spec_helper'

describe Tag do

  after(:each) { Tag.delete_all }

  context "Return ids" do
    it "should return one id" do
      Tag.create_tags(['wow', 'wow']).count.should eq(1)
    end

    it "should return new ids" do
      Tag.create_tags(['wow', 'wow2']).count.should eq(2)
    end

    it "should return empty array" do
      Tag.create_tags([]).should eq([])
    end
  end

end
