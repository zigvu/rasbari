Video::Engine.routes.draw do
  resources :streams
  root to: "streams#index"
end
