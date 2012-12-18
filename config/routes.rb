Leaveapp::Application.routes.draw do
  root :to => 'home#index'
  
  scope 'user', :as => 'user' do
    match '' => 'user#index', :via => :get
    match 'list' => 'user#list', :as => :list, :via => [:get, :post]
    match 'new' => 'user#new', :as => :new, :via => :get
    match 'create' => 'user#create', :as => :create, :via => :post
    match 'edit(/:id)' => 'user#edit', :as => :edit, :via => :get
    match 'update(/:id)' => 'user#update', :as => :update, :via => :post
    match 'delete' => 'user#destroy', :as => :delete, :via => :post
  end
  
  scope 'designation', :as => 'designation' do
    match '' => 'designation#index', :via => :get
    match 'list' => 'designation#list', :as => :list, :via => [:get, :post]
    match 'new' => 'designation#new', :as => :new, :via => :get
    match 'create' => 'designation#create', :as => :create, :via => :post
    match 'edit(/:id)' => 'designation#edit', :as => :edit, :via => :get
    match 'update(/:id)' => 'designation#update', :as => :update, :via => :post
    match 'delete' => 'designation#destroy', :as => :delete, :via => :post
  end
  
  scope 'empstatus', :as => 'empstatus' do
    match '' => 'employment_status#index', :via => :get
    match 'list' => 'employment_status#list', :as => :list, :via => [:get, :post]
    match 'new' => 'employment_status#new', :as => :new, :via => :get
    match 'create' => 'employment_status#create', :as => :create, :via => :post
    match 'edit(/:id)' => 'employment_status#edit', :as => :edit, :via => :get
    match 'update(/:id)' => 'employment_status#update', :as => :update, :via => :post
    match 'delete' => 'employment_status#destroy', :as => :delete, :via => :post
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
