Analysis::Engine.routes.draw do
  resources :minings do
    member do
      get 'set/:set_id' => 'minings#mine', as: :mine
      get 'progress/:set_id' => 'minings#progress', as: :progress
    end

    resources :sequence_viewer_workflow, only: [:show, :update], controller: 'minings/sequence_viewer_workflow'
    resources :confusion_finder_workflow, only: [:show, :update], controller: 'minings/confusion_finder_workflow'

  end

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      post 'frames/update_annotations'
      get 'frames/localization_data'
      get 'frames/heatmap_data'

      get 'minings/set_details'
      get 'minings/full_localizations'
      get 'minings/full_annotations'

      get 'minings/confusion'
    end
  end


  root to: "minings#index"
end
