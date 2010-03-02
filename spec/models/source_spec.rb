require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Source do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :site_url => "value for site_url"
    }
  end

  it "should create a new instance given valid attributes" do
    Source.create!(@valid_attributes)
  end
end
