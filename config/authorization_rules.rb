authorization do

  role :admin do
    has_permission_on [:sources, :issues, :pages, :projects], :to => [:index, :show, :new, :edit, :create, :update, :destroy]
    has_permission_on :users, :to => [:show, :new, :edit, :create, :update]
    has_permission_on :carts, :to => [:show, :add_page, :remove_page, :empty]
  end

  role :user do
    has_permission_on [:sources, :issues, :pages], :to => [:index, :show]
    has_permission_on :users, :to => [:show, :edit, :update]
    has_permission_on :search_queries, :to => [:index]
  end

  role :loader do
    includes :user
    # удалять источники (вместе со всеми выпусками разрешается только admin'у)
    has_permission_on :sources, :to => [:index, :show, :new, :edit, :create, :update]
    has_permission_on [:issues, :pages], :to => [:index, :show, :new, :edit, :create, :update, :destroy]
  end

  role :searcher do
    includes :user
    has_permission_on :sources, :to => [:index, :show, :new, :edit, :create, :update]
    has_permission_on [:issues, :pages, :projects], :to => [:index, :show, :new, :edit, :create, :update, :destroy]
    has_permission_on :carts, :to => [:show, :add_page, :remove_page, :empty]
  end

end
