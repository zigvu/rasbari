require 'fileutils'
require 'find'

class EngineCreator
  attr_accessor :engineFileName, :engineName

  def initialize(name)
    raise "Name should be in camel case" if name == name.camelize

    @engineFileName = name
    @engineName = name.classify

    setSampleEngine
    createEngine
    printTodo
  end

  def setSampleEngine
    @sampleEngineFileName = "sample_engine"
    @sampleEngineName = "SampleEngine"

    @sampleEngineLocation = "engines/#{@sampleEngineFileName}"
    raise "Sample engine doesn't exists at #{@sampleEngineLocation}" if !Dir.exists?(@sampleEngineLocation)
  end

  def createEngine
    copyEngine
    changeFiles
  end

  def copyEngine
    @engineLocation = "engines/#{@engineFileName}"
    raise "Engine already exists at #{@engineLocation}" if Dir.exists?(@engineLocation)

    FileUtils.cp_r(@sampleEngineLocation, @engineLocation)
  end

  def changeFiles
    # if directory needs renaming
    allFiles = Find.find("engines/#{@engineFileName}").map{ |f| f }
    allFiles.each do |f|
      if File.directory?(f) && f.include?("#{@sampleEngineFileName}")
        puts "Renaming directory: #{f}"
        newF = f.gsub("#{@sampleEngineFileName}", "#{@engineFileName}")
        FileUtils.mv(f, newF)
      end
    end
    # if file needs renaming
    allFiles = Find.find("engines/#{@engineFileName}").map{ |f| f }
    allFiles.each do |f|
      if !File.directory?(f) && File.basename(f).include?("#{@sampleEngineFileName}")
        puts "Renaming file: #{f}"
        newF = f.gsub("#{@sampleEngineFileName}", "#{@engineFileName}")
        FileUtils.mv(f, newF)
      end
    end
    # grep through all files changing occurence
    allFiles = Find.find("engines/#{@engineFileName}").map{ |f| f }
    allFiles.each do |f|
      if !File.directory?(f)
        text = File.read(f)
        if text.include?("#{@sampleEngineFileName}") || text.include?("#{@sampleEngineName}")
          puts "Rewording file: #{f}"
          text = text.gsub("#{@sampleEngineFileName}", "#{@engineFileName}")
          text = text.gsub("#{@sampleEngineName}", "#{@engineName}")
          File.open(f, "w") { |file| file.puts text }
        end
      end
    end
  end

  def printTodo
    puts ""
    puts "Following files need to be manually updated:"
    puts ""
    allFiles = Find.find("engines/#{@engineFileName}").map{ |f| f }
    allFiles.each do |f|
      if !File.directory?(f)
        text = File.read(f)
        if text.include?("TODO")
          puts f
        end
      end
    end
    puts ""
    puts "Following files need to be updated with new engine information:"
    puts ""
    puts "Gemfile"
    puts "config/application.rb"
  end
end
