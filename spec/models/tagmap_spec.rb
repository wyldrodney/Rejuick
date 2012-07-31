require 'spec_helper'

describe Tagmap do

  before(:each) do
    @otag = stub(Tag)

    @post = stub(Post)
    @post.stub(:id).and_return(1)
    @post.stub(:tags).and_return(@otag)
  end

  after(:each) { Tagmap.delete_all }


  context "Perform tagmaps" do
    it "should create one record" do
      @otag.stub(:delete_all).and_return(nil)

      Tagmap.perform_tagmaps([1], @post)

      Tagmap.count.should eq(1)
    end

    it "should leave no records in table" do
      @otag.stub(:delete_all) { Tagmap.delete_all }

      Tagmap.perform_tagmaps([1], @post)
      Tagmap.perform_tagmaps([], @post)

      Tagmap.count.should eq(0)
    end
  end

end
