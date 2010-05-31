# encoding: utf-8

class SourcesController < ApplicationController
  before_filter :login_required
  filter_resource_access
  cache_sweeper :source_sweeper, :only => [:create, :update, :destroy]

  def index
    redirect_to :controller => 'home', :action => 'index'
  end

  # не используется, кандидат на удаление
  def show
    @source = Source.find(params[:id])
  end

  def new
    @source = Source.new

  end

  def edit
    @source = Source.find(params[:id])

  end

  def create
    @source = Source.new(params[:source])

    if @source.save
      flash[:notice] = t 'source.flash.notice.create'
      redirect_to_target_or_default root_url
    else
      flash[:notice] = t 'source.flash.error.create'
      render :action => 'new'
    end
  end

  def update
    @source = Source.find(params[:id])

    if @source.update_attributes(params[:source])
      flash[:notice] = t 'source.flash.notice.update'
      redirect_to(@source)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    redirect_to(sources_url)
  end

end
