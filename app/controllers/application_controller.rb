class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation

  helper :all
  helper_method :sources, :cart

  before_filter {|c| Authorization.current_user = c.current_user}

  protected

    def permission_denied
      flash[:error] = t 'flash.access_restriction'
      redirect_to root_url
    end

  private

    def cart
      return current_user.cart if current_user.cart
      current_user.cart = Cart.new
      current_user.cart
    end

    def sources( ids = [], order_by = 'title' )
      return @sources if defined?(@sources)
      @sources = \
        if ids.any? and ids.size != Source.count
          Source.find(ids, :order => order_by)
        else
          Source.all(:order => order_by)
        end
    end

end

class Calendar
  attr_accessor :month, :year,
    :highlight_dates, :active_dates,
    :prev_month_active_date, :next_month_active_date,
    :prev_year_active_date, :next_year_active_date,
    :highlight_today, :current_date

  def initialize(options = {})
    @month = options[:month]
    @year = options[:year]
    @highlight_dates = options[:highlight_dates]
    @active_dates = options[:active_dates]
    @prev_month_active_date = options[:prev_month_active_date]
    @next_month_active_date = options[:next_month_active_date]
    @prev_year_active_date = options[:prev_year_active_date]
    @next_year_active_date = options[:next_year_active_date]
    @highlight_today = options[:highlight_today]
    @current_date = options[:current_date]
  end

end
