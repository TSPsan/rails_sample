Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  controller :static_pages do
		root 'static_pages#home'
		get '/help',    to: 'static_pages#help'
		get '/about',   to: 'static_pages#about'
		get '/contact', to: 'static_pages#contact'
	end

  controller :users do
		get  '/signup', to: 'users#new'
		post '/signup', to: 'users#create'
		resources :users do
			member do
				get :following, :followers
			end
		end
	end

  controller :sessions do
		get    '/login',       to: 'sessions#new'
		post   '/login',       to: 'sessions#create'
		delete '/logout',      to: 'sessions#destroy'
		post   '/guest_login', to: 'sessions#guest_login'
  end

  controller :microposts do
		resources :microposts,    only: [:create, :destroy]
	end

  controller :relationships do
		resources :relationships, only: [:create, :destroy]
  end
end
