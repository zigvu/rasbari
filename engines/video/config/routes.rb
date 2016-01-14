Video::Engine.routes.draw do
  resources :captures, only: [:new, :show, :destroy] do
    resources :workflow, only: [:show, :update], controller: 'captures/workflow'
    member do
      get 'start_vnc'
      get 'force_stop'
    end
  end
  resources :streams
  root to: "streams#index"
end
