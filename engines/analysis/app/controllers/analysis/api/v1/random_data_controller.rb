require_dependency "analysis/application_controller"

module Analysis
  class Api::V1::RandomDataController < ApplicationController

    # GET api/v1/minings/get_data
    def get_data
      random  = Random.new( 28)
      label_0 = Array.new(30)
      label_1 = Array.new(30)
      label_2 = Array.new(30)
      (0 ... 30) .each { |i| 
        label_0[i] = { :x => random.rand(-0.9 .. -0.8), :y => random.rand(0.2 .. 0.6), :label => 'label-0' }
        label_1[i] = { :x => random.rand(-0.3 .. 0.3), :y => random.rand(0.4 .. 0.8), :label => 'label-1' }
        label_2[i] = { :x => random.rand(0.2 .. 0.6), :y => random.rand(-0.6 .. 0.6), :label => 'label-2'}
      }
      retVal = label_0 + label_1 + label_2
      render json: retVal
    end
  end
end
