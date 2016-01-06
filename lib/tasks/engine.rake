load 'lib/helpers/engine_creator.rb'
load 'lib/helpers/workflow_creator.rb'

namespace :engine do
  desc "Create new engine based on sample engine"
  task create: :environment do
    engineName = ENV['engine_name']
    if (engineName == nil)
      puts "Usage: rake engine:create engine_name=<underscore_name>"
      puts "This will generate a new engine based on sample engine."
      puts "Exiting"
    else
      EngineCreator.new(engineName)
    end
  end

  desc "Create new workflow based on sample workflow"
  task workflow: :environment do
    engineName = ENV['engine_name']
    trackerName = ENV['tracker_name']
    parentName = ENV['parent_name']
    stepNames = ENV['step_names']
    if (engineName == nil || trackerName == nil || parentName == nil || stepNames == nil)
      puts "Usage: rake engine:workflow engine_name=<underscore_name> tracker_name=<underscore_name> parent_name=<underscore_name> step_names=<quoted_space_delimited_underscore_names> "
      puts "This will generate a new workflow based on sample workflow."
      puts ""
      puts "Example:"
      puts 'rake engine:workflow engine_name=setting tracker_name=machine_setting parent_name=machine step_names="step_one step_two"'
      puts ""
      puts "Exiting"
    else
      WorkflowCreator.new(engineName, trackerName, parentName, stepNames)
    end
  end
end
