class HomeController < ApplicationController
  before_filter :login_required

  def index
    store_target_location

  end

end
