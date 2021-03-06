require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/new.html.erb" do
  include PagesHelper

  before(:each) do
    assigns[:page] = stub_model(Page,
      :new_record? => true
    )
  end

  it "renders new page form" do
    render

    response.should have_tag("form[action=?][method=post]", pages_path) do
    end
  end
end
