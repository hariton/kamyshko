class UserSessionsController < ApplicationController
  before_filter :login_required, :only => :destroy

  layout nil

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :controller => 'home', :action => 'index'
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to_target_or_default login_url
  end

end
