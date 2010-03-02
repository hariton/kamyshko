ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.resource :user_session

  map.root :controller => 'home', :action => 'index'
  map.resource :account, :controller => 'users'

  # XXX рефакторить
  map.empty_cart 'cart/empty', :controller => 'cart', :action => 'empty'
  map.cart 'cart/:action', :controller => 'cart', :action => 'show'
  map.add_to_cart 'cart/add/:page_id', :controller => 'cart', :action => 'add_page'
  map.remove_from_cart 'cart/remove/:page_id', :controller => 'cart', :action => 'remove_page'
  map.resources :cart do |cart|
    cart.resources :pages
  end

  map.resources :users do |user|
    user.resources :projects do |project|
      project.resources :pages
    end
  end

  map.resources :sources do |source|
    source.resources :issues do |issue|
      issue.resources :pages
    end
  end

  map.search_queries 'search_queries', :controller => 'search_queries', :action => 'index'

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
