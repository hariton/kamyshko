require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Issue do
  before(:each) do
    @valid_attributes = {
      :source => ,
      :date => Date.today,
      :number => 1,
      :pdf_file_size => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Issue.create!(@valid_attributes)
  end
end
