# encoding: utf-8

class ProjectsController < ApplicationController
  before_filter :login_required
  filter_resource_access

  def index
    @searchers = User.all :joins => :roles, :conditions => {:roles => {:name => 'searcher'}}
    # текущего пользователя передвигаем на первое место
    @searchers = [current_user] + (@searchers - [current_user]) if @searchers.include?(current_user)
  end

  def show
    @project = Project.find(params[:id])

  end

  def new
    @project = Project.new

  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = t 'project.flash.notice.create'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = t 'project.flash.notice.update'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

end
