Kheer::Engine.routes.draw do
  resources :capture_evaluations, only: [:index, :show, :new, :destroy] do
    resources :workflow, only: [:show, :update], controller: 'capture_evaluations/workflow'
  end
  resources :chia_models do
    member do
      get 'minis'
      get 'finalize'
    end
  end
  resources :detectables
  resources :iterations, only: [:show] do
    resources :workflow, only: [:show, :update], controller: 'iterations/workflow'
  end
  root to: "chia_models#index"
end
