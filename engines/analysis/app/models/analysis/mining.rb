module Analysis
  class Mining
    include Mongoid::Document
    include Mongoid::Timestamps

    after_create :createMiningData

    # meta data
    # -------------------------------------------
    field :nm, as: :name, type: String
    field :ds, as: :description, type: String
    field :ui, as: :user_id, type: Integer
    field :zst, as: :zstate, type: String
    field :ztp, as: :ztype, type: String

    # mining setup
    # -------------------------------------------
    field :cil, as: :chia_model_id_loc, type: Integer
    field :cia, as: :chia_model_id_anno, type: Integer
    field :cls, as: :clip_ids, type: Array
    # format
    # {setId: [{:clip_id, :loc_count, fn_count:, fn_visited_count:}, ]}
    field :cs, as: :clip_sets, type: Hash
    # format
    # {setId: boolean, }  -> true if done, else false
    field :csp, as: :clip_sets_progress, type: Hash


    # index for faster traversal during ordering
    # -------------------------------------------
    index({ user_id: 1 }, { background: true })

    # polymorphism requirements
    # -------------------------------------------

    def createMiningData
      # if States::MiningType.new(self).isZdistFinder?
      #   self.create_md_zdist_finder
      # elsif States::MiningType.new(self).isChiaVersionComparer?
      #   self.create_md_chia_version_comparer
      # elsif States::MiningType.new(self).isZdistDifferencer?
      #   self.create_md_zdist_differencer
      # elsif States::MiningType.new(self).isConfusionFinder?
      #   self.create_md_confusion_finder
      # elsif States::MiningType.new(self).isSequenceViewer?
      #   # don't need extra data
      # elsif States::MiningType.new(self).isDetFinder?
      #   self.create_md_det_finder
      # end
    end

    # convenience methods
    # -------------------------------------------

    def state
      Analysis::MiningStates.new(self)
    end
    def type
      Analysis::MiningTypes.new(self)
    end

    def user
      return User.find(self.user_id)
    end

    # default scoping to order documents by updated at field
    default_scope ->{ order_by(:updated_at => :desc) }

    # data for mining is embedded in one of the sub documents
    # embeds_one :md_zdist_finder
    # embeds_one :md_chia_version_comparer
    # embeds_one :md_zdist_differencer
    # embeds_one :md_confusion_finder
    # embeds_one :md_det_finder
  end
end
