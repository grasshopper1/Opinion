Opinion::Engine.routes.draw do
	resources :polls do
		resources :options
	end
	root 'polls#index'
end
