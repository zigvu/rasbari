Analysis::Engine.routes.draw do
  resources :minings do
    resources :sequence_viewer_workflow, only: [:show, :update], controller: 'minings/sequence_viewer_workflow'
  end
  root to: "minings#index"
end
