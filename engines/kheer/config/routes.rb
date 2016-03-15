Kheer::Engine.routes.draw do
  resources :chia_models do
    member do
      get 'minis'
    end
  end
  resources :detectables
  root to: "chia_models#index"
end
