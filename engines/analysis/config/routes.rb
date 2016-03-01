Analysis::Engine.routes.draw do
  resources :minings do
    member do
      get 'set/:set_id' => 'minings#mine', as: :mine
      get 'progress/:set_id' => 'minings#progress', as: :progress
    end
    
    resources :sequence_viewer_workflow, only: [:show, :update], controller: 'minings/sequence_viewer_workflow'
  end

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      get 'minings/set_details'
      get 'minings/full_localizations'
      get 'minings/full_annotations'
    end
  end


  root to: "minings#index"
end
