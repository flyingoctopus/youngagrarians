Youngagrarians::Application.routes.draw do
scope "/~youngagr" do
  resources :categories
    match 'locations/excel_import' => 'locations#excel_import'
    match 'locations/filtered/:filtered' => 'locations#index', :as => :locations_filtered
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

end
end
