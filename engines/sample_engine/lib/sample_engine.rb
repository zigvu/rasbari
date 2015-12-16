require "simple_form"
require "draper"

require "sample_engine/engine"

module SampleEngine
  def self.files_to_load
    app = File::expand_path('../../app', __FILE__)
    templateFolders = ["#{app}/assets", "#{app}/controllers", "#{app}/models", "#{app}/views"]
    nonTemplateFolders = Dir["#{app}/*"] - templateFolders
    nonTemplateFiles = []
    nonTemplateFolders.each do |ntf|
      # assume that all files are namespaced
      Dir["#{ntf}/*/**"].each do |f|
        nonTemplateFiles << File.join(File.dirname(f), File.basename(f, ".*"))
      end
    end

    nonTemplateFiles
  end
end
