class CartController < ApplicationController
  before_filter :login_required

  def show
    store_target_location

    @cart_page = cart.cart_pages.find_by_position(params[:page] || 1)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end

  end

  def add_page
    @page = Page.find(params[:page_id])
    if cart.pages.include?(@page)
      flash[:error] = t 'cart.flash.error.duplicate'
    else
      cart.add_page(@page)
      cart.save
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def remove_page
    @page = cart.pages.find(params[:page_id])
    cart.remove_page(@page)
    cart.save

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def empty
    cart.empty
    cart.save
    flash[:notice] = t 'cart.flash.notice.empty'
    redirect_to_target_or_default root_url
  end

end
