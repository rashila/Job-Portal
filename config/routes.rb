JobPortal::Application.routes.draw do
  
  devise_for :users
  
  #resources :positions

  resources :candidates do
    resources :contactinfos
  end
  resources :companies do
    resources :contactinfos
  end
  #resources :companies do
    resources :positions
  #end

  match "/positions/:id/show" => 'positions#show'
  match "/positions/:company_id/new" => 'positions#new'
  match "/positions/:company_id/index" => "positions#index"
  match "/create_position" => 'positions#create'
  
  match "/candidates/:id/show" => 'candidates#show'
  match "/candidates/:id/welcome" => "candidates#welcome", :as=> :candidate_welcome 
   
  match "/companies/:id/show" => 'companies#show'   
  match "/destroy_positions" => 'positions#destroy'
  match "/companies/:id/welcome" => "companies#welcome", :as=> :company_welcome
  match "/companies/:id/company_resumes" => "companies#company_resumes", :as => :company_resumes
  match '/companies/resume_download/:id/:type/:attached_file_name(.:format)' => 'companies#resume_download', :as => 'resume_download'


  
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
  root :to => "home#index"

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'
end
