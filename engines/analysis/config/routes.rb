Analysis::Engine.routes.draw do
  resources :minings
  root to: "minings#index"
end
