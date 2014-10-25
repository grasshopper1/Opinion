Opinion::Engine.routes.draw do
	resources :polls

	root 'polls#index'
end
