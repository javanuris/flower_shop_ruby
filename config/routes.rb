Rails.application.routes.draw do
  get 'order_items/create'

  get 'order_items/update'

  get 'order_items/destroy'

  get 'carts/show'

  devise_for :users
	resources :products do
	resources :reviews
	end
	root 'products#index'
	
   resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]
end
