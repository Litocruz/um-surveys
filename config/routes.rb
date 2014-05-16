UmSurveys::Application.routes.draw do
  get "participants/index"
  get "participants/import"
  #post "participants/send_mails"
  resources :users do
    collection {delete :destroy_multiple}
  end
  resources :sessions, only: [:new, :create, :destroy]
  #root  'users#index'
  match '/signup',  to: 'users#new',         via: 'get'
  match '/signin',  to: 'sessions#new',      via: 'get'
  match '/signout',  to: 'sessions#destroy', via: 'delete'

  resources :surveys do
    get 'results', on: :member
    get 'toggle_status', on: :member
    get 'clone_survey', on: :member
    collection {delete :destroy_multiple}
    resources :questions do
      collection {post :reorder}
      collection {delete :destroy_or_presence_multiple}
      collection {post :destroy_or_presence_multiple}
    end
    resources :answer_groups, only: [:new, :create]
    resources :participants do
      collection { post :import }
      collection { post :send_mails }
    end
  end


  get "/surveys/:survey_id/answer_groups/new" => "answer_group#new", :as => :survey_answer_participant
  #root  'surveys#index'
  root to: 'static_pages#home'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
