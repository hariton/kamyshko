require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SourcesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "sources", :action => "index").should == "/sources"
    end

    it "maps #new" do
      route_for(:controller => "sources", :action => "new").should == "/sources/new"
    end

    it "maps #show" do
      route_for(:controller => "sources", :action => "show", :id => "1").should == "/sources/1"
    end

    it "maps #edit" do
      route_for(:controller => "sources", :action => "edit", :id => "1").should == "/sources/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "sources", :action => "create").should == {:path => "/sources", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "sources", :action => "update", :id => "1").should == {:path =>"/sources/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "sources", :action => "destroy", :id => "1").should == {:path =>"/sources/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/sources").should == {:controller => "sources", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/sources/new").should == {:controller => "sources", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/sources").should == {:controller => "sources", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/sources/1").should == {:controller => "sources", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/sources/1/edit").should == {:controller => "sources", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/sources/1").should == {:controller => "sources", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/sources/1").should == {:controller => "sources", :action => "destroy", :id => "1"}
    end
  end
end
