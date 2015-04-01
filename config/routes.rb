Rails.application.routes.draw do
  
  root :to => 'main_pages#home'

  get    'register'   => 'users#new'
  get    'about'      => 'main_pages#about'
  get    'help'       => 'main_pages#help'
  get    'login'      => 'sessions#new'
  post   'login'      => 'sessions#create'
  delete 'logout'     => 'sessions#destroy'
  get 'users/existing' => 'users#existing', :as => 'existing'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :recipes
  resources :ingredients
  resources :measurements
  resources :recipe_ingredients,  except: [:show]
  resources :follows,             only:   [:create, :destroy]
  resources :comments,            except: [:show]
  resources :ratings,             except: [:show]
  resources :checklists,          except: [:show]
  resources :checklist_pictures,  except: [:show]
  resources :account_activations, only:   [:edit]
  resources :password_resets,     only:   [:new, :create, :edit, :update]
  
    #If path doesn't match a defined route send traffic to root
  match "*path", to: "main_pages#home", via: :all
end
