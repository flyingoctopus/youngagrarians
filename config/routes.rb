Youngagrarians::Application.routes.draw do
scope "/~youngagr" do
  resources :categories

  match 'locations/excel_import' => 'locations#excel_import'
  resources :locations

    match 'locations/:ids/multi-edit' => 'locations#edit', :as => :multi_edit
    match 'locations/:ids/multi-update' => 'locations#update', :as => :multi_update
    match 'locations/:ids/multi-delete' => 'locations#destroy', :as => :multi_delete
    match 'locations/:ids/approve' => 'locations#approve', :as => :approve

  get "home/index"
  root :to => "home#index"

  # Authentication flow
  get  '/login'                => 'accounts#login',              :as => :login
  post '/login'                => 'accounts#login_post',         :as => :login_post
  post '/login.json'           => 'accounts#login_post',         :as => :login_post_json, :format => 'json'
  get  '/logout'               => 'accounts#logout',             :as => :logout
  get  '/signup'               => 'accounts#new',                :as => :signup
  post '/signup'               => 'accounts#create',             :as => :create_account
  get  '/forgot_password'      => 'accounts#forgot_password',    :as => :forgot_password
  post '/forgot_password'      => 'accounts#retrieve_password',  :as => :retrieve_password
  get  '/password_sent'        => 'accounts#password_sent',      :as => :password_sent
  get  '/password_reset/:code' => 'accounts#password_reset',     :as => :password_reset
  put  '/password_reset/:code' => 'accounts#reset_password',     :as => :reset_password

  get  '/verify_credentials'   => 'accounts#verify_credentials', :as => :verify_credentials

  post '/search' => 'locations#search', :as => :search

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
end
