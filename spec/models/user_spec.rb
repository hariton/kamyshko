require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :login => "value for login",
      :name => "value for name",
      :email => "value for email",
      :phone => "value for phone",
      :crypted_password => "value for crypted_password",
      :password_salt => "value for password_salt",
      :persistence_token => "value for persistence_token",
      :single_access_token => "value for single_access_token",
      :perishable_token => "value for perishable_token",
      :login_count => 1,
      :failed_login_count => 1,
      :last_request_at => Time.now,
      :current_login_at => Time.now,
      :last_login_at => Time.now,
      :current_login_ip => "value for current_login_ip",
      :last_login_ip => "value for last_login_ip"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
