Setting::Engine.routes.draw do
  resources :machines
  root to: "machines#index"
end
