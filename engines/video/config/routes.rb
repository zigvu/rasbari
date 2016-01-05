Video::Engine.routes.draw do
  resources :captures, only: [:new, :show, :destroy] do
    resources :workflow, only: [:show, :update], controller: 'captures/workflow'
  end
  resources :streams
  root to: "streams#index"
end
