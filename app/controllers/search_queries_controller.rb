# encoding: utf-8

class SearchQueriesController < ApplicationController
  before_filter :login_required

  def index

    store_target_location

    search_params = {
      :match_mode => :extended,
      :order => :date,
      :sort_mode => :desc,
      :with => {},
      :page => params[:page], :per_page => 10,
      :retry_stale => true
    }

    search_query = current_user.search_query

    date_start = search_query.option_search_date_start
    date_end = search_query.option_search_date_end

    search_params[:with][:date] = date_start.to_time..date_end.to_time
    search_params[:with][:source_id] = search_query.option_search_in_sources.split(',').collect(&:to_i)

    @pages = Page.search( search_query.query, search_params )

    # фильтрация:
    # Article.search 'pancakes',
    #   :conditions => {:subject => 'tasty'},
    #   :with       => {:created_at => 1.week.ago..Time.now}

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end

  end

  def create

    search_query = SearchQuery.create(:query => params[:search_query])

    search_query.option_search_date_start = Date.parse params[:search_date_start]
    search_query.option_search_date_end = Date.parse params[:search_date_end]

    if params[:search_in_sources] && params[:search_in_sources].any?
      search_query.option_search_in_sources = params[:search_in_sources].join(',')
    end

    search_query.launched_at = Time.now

    current_user.search_query = search_query
    current_user.save

    redirect_to :action => 'index'

  end

end
