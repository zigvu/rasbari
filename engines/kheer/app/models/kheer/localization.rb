module Kheer
	class Localization
		include Mongoid::Document

		# meta data for indexing
		# -------------------------------------------
		field :cl, as: :clip_id, type: Integer
		field :ci, as: :chia_model_id, type: Integer

		field :fn, as: :frame_number, type: Integer

		# scores
		# -------------------------------------------
		field :di, as: :detectable_id, type: Integer

		field :ps, as: :prob_score, type: Float
		field :zd, as: :zdist_thresh, type: Float
		field :sl, as: :scale, type: Float

		field :x, type: Integer
		field :y, type: Integer
		field :w, type: Integer
		field :h, type: Integer


		# index for faster traversal during ordering
		# -------------------------------------------
		index({ clip_id: 1 }, { background: true })
		index({ chia_model_id: 1 }, { background: true })
		index({ frame_number: 1 }, { background: true })

		# convenience methods
		# -------------------------------------------

		def detectable
			return Detectable.find(self.detectable_id)
		end

		def clip
			return Video::Clip.find(self.clip_id)
		end

		def chiaModel
			return ChiaModel.find(self.chia_model_id)
		end
	end
end
