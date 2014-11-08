Opinion::Engine.routes.draw do
	resources :polls do
		resources :options do
			member do
				get :vote_up
			end
		end
		member do
			post :vote_up
			post :end
			post :activate
		end
	end
	root 'polls#index'
end
