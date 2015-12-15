load 'lib/helpers/engine_creator.rb'

namespace :engine do
  desc "Create new engine based on sample engine"
  task create: :environment do
    engineName = ENV['engine_name']
    if (engineName == nil)
      puts "Usage: rake engine:create engine_name=<camel_case_name>"
      puts "This will generate a new engine based on sample engine."
      puts "Exiting"
    else
      EngineCreator.new(engineName)
    end
  end
end
