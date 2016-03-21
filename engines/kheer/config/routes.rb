Kheer::Engine.routes.draw do
  resources :capture_evaluations, except: [:edit, :update]
  resources :chia_models do
    member do
      get 'minis'
    end
  end
  resources :detectables
  resources :iterations, only: [:show] do
    resources :workflow, only: [:show, :update], controller: 'iterations/workflow'
  end
  root to: "chia_models#index"
end
