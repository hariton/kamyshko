include ActionView::Helpers::UrlHelper
include ActionView::Helpers::TagHelper

class IssuesController < ApplicationController
  before_filter :login_required
  cache_sweeper :source_sweeper, :only => [:create, :update, :destroy]

  helper_method :date_link, :navigation_dates

  def index
    @source = Source.find(params[:source_id])
    @issues = @source.issues.active

  end

  def show

    store_target_location

    @source = Source.find(params[:source_id])
    @issue = @source.issues.find(params[:id])
    @page = @issue.pages.find_by_number(params[:page] || 1)
    @preview = params[:preview] || 'medium'

    @navigation_dates = navigation_dates :sources => [ @source ], :date => @issue.date

    @calendar = Calendar.new \
        :month => @issue.date.month,
        :year => @issue.date.year,
        :highlight_dates => [ @issue.date.day ],
        :active_dates => calendar_active_dates( navigation_dates[:current_month_dates] ),
        :prev_month_active_date => @navigation_dates[:prev_month_date],
        :next_month_active_date => @navigation_dates[:next_month_date],
        :prev_year_active_date => @navigation_dates[:prev_year_date],
        :next_year_active_date => @navigation_dates[:next_year_date],
        :highlight_today => true,
        :current_date => @issue.date

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end

  end

  def new
    @source = Source.find(params[:source_id])
    @issue = @source.issues.build

  end

  def edit
    @source = Source.find(params[:source_id])
    @issue = @source.issues.find(params[:id])

  end

  def create
    @source = Source.find(params[:source_id])

    @issue = @source.issues.build(params[:issue])
    @issue.pdf_file = params[:issue][:pdf_file]
    @issue.txt_file = params[:issue][:txt_file]

    if @issue.save
      flash[:notice] = t 'issue.flash.notice.create'
      redirect_to_target_or_default root_url
    else
      flash[:notice] = t 'issue.flash.error.create'
      render :action => 'new'
    end

  end

  def update
    @source = Source.find(params[:source_id])
    @issue = Issue.find(params[:id])

    if @issue.update_attributes(params[:issue])
      flash[:notice] = t 'issue.flash.notice.update'
      redirect_to_target_or_default root_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @source = Source.find(params[:source_id])
    @issue = Issue.find(params[:id])
    @issue.destroy

    redirect_to root_url
  end

  private

  def navigation_dates( options = {} )

    return @navigation_dates if defined?(@navigation_dates)

    options[:sources] ||= []
    options[:date] ||= Date.today

    @navigation_dates = {}

    date = options[ :date ]
    ids = options[ :sources ].collect( &:id ) * ', '

    current_day = date.to_formatted_s(:db)

    current_month_first_day = date.beginning_of_month.to_formatted_s(:db)
    current_month_last_day = date.end_of_month.to_formatted_s(:db)

    next_month_last_day = date.next_month.end_of_month.to_formatted_s(:db)

    prev_year_current_month_last_date = date.end_of_month.years_ago(1)
    prev_year_current_month_last_day = prev_year_current_month_last_date.to_formatted_s(:db)
    prev_year_first_day = prev_year_current_month_last_date.beginning_of_year.to_formatted_s(:db)

    next_year_current_month_last_date = date.end_of_month.years_since(1)
    next_year_current_month_last_day = date.end_of_month.years_since(1).to_formatted_s(:db)
    next_year_first_day = next_year_current_month_last_date.beginning_of_year.to_formatted_s(:db)

    @navigation_dates[:current_month_dates] = \
      ActiveRecord::Base.connection.select_values(
        %{SELECT DISTINCT(date) FROM issues WHERE active = true AND source_id IN (#{ids}) AND date >= '#{current_month_first_day}' AND date <= '#{current_month_last_day}' }
      ).collect( &:to_date )

    prev_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date < '#{current_day}' ORDER BY date DESC LIMIT 1 }
    )
    @navigation_dates[:prev_date] = \
      prev_issue_timestamp.to_date if prev_issue_timestamp and prev_issue_timestamp.any?

    next_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date > '#{current_day}' ORDER BY date LIMIT 1 }
    )
    @navigation_dates[:next_date] = \
      next_issue_timestamp.to_date if next_issue_timestamp and next_issue_timestamp.any?

    prev_month_last_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date < '#{current_month_first_day}' ORDER BY date DESC LIMIT 1 }
    )
    @navigation_dates[:prev_month_date] = \
      prev_month_last_issue_timestamp.to_date if prev_month_last_issue_timestamp and prev_month_last_issue_timestamp.any?

    next_month_last_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date > '#{current_month_last_day}' ORDER BY date LIMIT 1 }
    )
    @navigation_dates[:next_month_date] = \
      next_month_last_issue_timestamp.to_date if next_month_last_issue_timestamp and next_month_last_issue_timestamp.any?

    prev_year_month_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date > '#{prev_year_first_day}' AND date < '#{prev_year_current_month_last_day}' ORDER BY date DESC LIMIT 1 }
    )
    @navigation_dates[:prev_year_date] = \
      prev_year_month_issue_timestamp.to_date if prev_year_month_issue_timestamp and prev_year_month_issue_timestamp.any?

    next_year_month_issue_timestamp = ActiveRecord::Base.connection.select_value(
      %{SELECT date FROM issues WHERE active = true AND source_id IN (#{ids}) AND date >= '#{next_year_first_day}' AND date <= '#{next_year_current_month_last_day}' ORDER BY date DESC LIMIT 1 }
    )
    @navigation_dates[:next_year_date] = \
      next_year_month_issue_timestamp.to_date if next_year_month_issue_timestamp and next_year_month_issue_timestamp.any?

    @navigation_dates

  end

  def calendar_active_dates( dates = [] )
    active_dates = {}
    dates.each do | date |
      if @issue.date.month == date.month
        day = date.day
        active_dates.update( { day => date_link( date, day ) } )
      end
    end
    active_dates
  end

  def date_link( date, text, placeholder = nil, html_options = nil )
    return placeholder unless date
    issue = @source.issues.find_by_date(date)
    link_to( text, [@source, issue], html_options ) if issue
  end

end
