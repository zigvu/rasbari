require 'fileutils'
require 'find'

class WorkflowCreator
  attr_accessor :engineFolder, :engineName, :trackerName, :parentName

  def initialize(engineName, trackerName, parentName, stepNames)
    raise "Engine name should be in underscore" if engineName == engineName.camelize
    raise "Tracker model name should be in underscore" if trackerName == trackerName.camelize
    raise "Parent model name should be in underscore" if parentName == parentName.camelize

    @engineFolder = "engines/#{engineName}"
    @engineName = engineName
    @trackerName = trackerName
    @parentName = parentName

    @stepNames = []
    stepNames.split(" ").each do |stepName|
      raise "Step name '#{stepName}' should be in underscore" if stepName == stepName.camelize
      @stepNames << stepName
    end

    @templateFolder = "lib/helpers/workflow"
    raise "Workflow template folder doesn't exist at #{@templateFolder}" if !Dir.exists?(@templateFolder)

    createTrackerController
    createWorkflowController
    createViews
    createWorkflows
    printTodo
  end
  # ----------------------------------------------------------------------------


  # ----------------------------------------------------------------------------
  # Create tracker controller
  def createTrackerController
    wf_file_in = "#{@templateFolder}/trackers_controller.rb"
    wf_file_out = "#{@engineFolder}/app/controllers/#{@engineName}/#{@trackerName.pluralize}_controller.rb"

    if !File.exists?(wf_file_in)
      raise "Sample tracker controller doesn't exists at #{wf_file_in}"
    end

    # copy file
    if File.exists?(wf_file_out)
      puts "Skipping tracker controller creation at #{wf_file_out}"
    else
      puts "Rewording tracker controller: #{wf_file_in}"
      text = File.read(wf_file_in)
      text = gsubCommon(text)
      File.open(wf_file_out, "w") { |file| file.puts text }
    end
  end
  # ----------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
  # Create worfklow controller
  def createWorkflowController
    wf_file_in = "#{@templateFolder}/workflow_controller.rb"

    wf_file_out_folder = "#{@engineFolder}/app/controllers/#{@engineName}/#{@trackerName.pluralize}"
    wf_file_out = "#{wf_file_out_folder}/workflow_controller.rb"
    FileUtils.mkdir_p(wf_file_out_folder)

    if !File.exists?(wf_file_in)
      raise "Sample workflow controller doesn't exists at #{wf_file_in}"
    end

    # copy file
    if File.exists?(wf_file_out)
      puts "Skipping workflow controller creation at #{wf_file_out}"
    else
      puts "Rewording workflow controller: #{wf_file_in}"
      text = File.read(wf_file_in)
      text = gsubCommon(text)

      replaceStepsWith = ""
      @stepNames.each do |stepName|
        replaceStepsWith += getWorkflowControllerShowStep(stepName)
      end
      text = text.gsub("XXX_REPLACE_SHOW_STEPS_XXX", "#{replaceStepsWith}")

      replaceStepsWith = ""
      @stepNames.each do |stepName|
        replaceStepsWith += getWorkflowControllerUpdateStep(stepName)
      end
      text = text.gsub("XXX_REPLACE_UPDATE_STEPS_XXX", "#{replaceStepsWith}")

      replaceStepsWith = ""
      @stepNames.each do |stepName|
        replaceStepsWith += ":#{stepName}, "
      end
      replaceStepsWith = replaceStepsWith[0..-3]
      text = text.gsub("XXX_REPLACE_SET_STEPS_XXX", "#{replaceStepsWith}")

      File.open(wf_file_out, "w") { |file| file.puts text }
    end
  end

  def getWorkflowControllerShowStep(stepName)
    return """
      when :#{stepName}
        @workflowObj = #{@engineName.camelize}::#{@trackerName.camelize}Workflow::#{stepName.camelize}.new(@#{@trackerName})
        @workflowObj.canSkip ? skip_step : @workflowObj.serve"""
  end
  def getWorkflowControllerUpdateStep(stepName)
    return """
      when :#{stepName}
        status, message = #{@engineName.camelize}::#{@trackerName.camelize}Workflow::#{stepName.camelize}.new(@#{@trackerName}).handle(params)"""
  end
  # ----------------------------------------------------------------------------


  # ----------------------------------------------------------------------------
  # Create views
  def createViews
    wf_views_folder_in = "#{@templateFolder}/views"
    wf_views_folder_out = "#{@engineFolder}/app/views/#{@engineName}/#{@trackerName.pluralize}/workflow"
    FileUtils.mkdir_p(wf_views_folder_out)

    if !Dir.exists?(wf_views_folder_in)
      raise "Sample view folder doesn't exists at #{wf_views_folder_in}"
    end

    # copy common buttons file
    wf_file_in = "#{wf_views_folder_in}/_common_buttons.html.erb"
    wf_file_out = "#{wf_views_folder_out}/_common_buttons.html.erb"
    if File.exists?(wf_file_out)
      puts "Skipping view common bottons creation at #{wf_file_out}"
    else
      puts "Rewording view common bottons: #{wf_file_in}"
      text = File.read(wf_file_in)
      text = gsubCommon(text)
      File.open(wf_file_out, "w") { |file| file.puts text }
    end

    # copy outershell file
    wf_file_in = "#{wf_views_folder_in}/_outershell.html.erb"
    wf_file_out = "#{wf_views_folder_out}/_outershell.html.erb"
    if File.exists?(wf_file_out)
      puts "Skipping view outershell creation at #{wf_file_out}"
    else
      puts "Rewording view outershell: #{wf_file_in}"
      text = File.read(wf_file_in)
      text = gsubCommon(text)
      File.open(wf_file_out, "w") { |file| file.puts text }
    end

    # copy steps
    wf_file_in = "#{wf_views_folder_in}/step.html.erb"
    @stepNames.each do |stepName|
      wf_file_out = "#{wf_views_folder_out}/#{stepName}.html.erb"
      if File.exists?(wf_file_out)
        puts "Skipping view step creation at #{wf_file_out}"
      else
        puts "Rewording view outershell: #{wf_file_in}"
        text = File.read(wf_file_in)
        text = gsubCommon(text)
        title = stepName.split("_").map{ |s| s.capitalize }.join(" ")
        text = text.gsub("XXX_REPLACE_STEP_TITLE_XXX", "#{title}")
        File.open(wf_file_out, "w") { |file| file.puts text }
      end
    end
    # done with all views
  end
  # ----------------------------------------------------------------------------


  # ----------------------------------------------------------------------------
  # Create worfklows
  def createWorkflows
    wf_file_in = "#{@templateFolder}/workflow_step.rb"
    wf_steps_folder_out = "#{@engineFolder}/app/workflows/#{@engineName}/#{@trackerName}_workflow"
    FileUtils.mkdir_p(wf_steps_folder_out)

    if !File.exists?(wf_file_in)
      raise "Sample workflow step doesn't exists at #{wf_file_in}"
    end

    # copy steps
    @stepNames.each do |stepName|
      wf_file_out = "#{wf_steps_folder_out}/#{stepName}.rb"
      if File.exists?(wf_file_out)
        puts "Skipping workflow step creation at #{wf_file_out}"
      else
        puts "Rewording workflow step: #{wf_file_in}"
        text = File.read(wf_file_in)
        text = gsubCommon(text)
        text = text.gsub("XXX_REPLACE_STEP_CLASS_XXX", "#{stepName.camelize}")
        File.open(wf_file_out, "w") { |file| file.puts text }
      end
    end
    # done with all steps
  end
  # ----------------------------------------------------------------------------


  # ----------------------------------------------------------------------------
  def printTodo
    puts ""
    puts "Following files need to be manually updated:"
    puts ""
    puts "#{@engineFolder}/config/routes.rb"
    puts ""
    puts "Look for intructions at:"
    puts "#{@templateFolder}/instructions.txt"
  end
  # ----------------------------------------------------------------------------

  def gsubCommon(_text)
    text = _text.gsub("sample_engine", "#{@engineName}")
    text = text.gsub("SampleEngine", "#{@engineName.camelize}")
    text = text.gsub("tracker", "#{@trackerName}")
    text = text.gsub("Tracker", "#{@trackerName.camelize}")
    text = text.gsub("parent", "#{@parentName}")
    text = text.gsub("Parent", "#{@parentName.camelize}")
    text
  end
end
