#!/usr/bin/env ruby 

# == Synopsis 
#   This is a sample description of the application.
#   Blah blah blah.
#
# == Examples
#   This command does blah blah blah.
#     ruby_cl_skeleton foo.txt
#
#   Other examples:
#     ruby_cl_skeleton -q bar.doc
#     ruby_cl_skeleton --verbose foo.html
#
# == Usage 
#   ruby_cl_skeleton [options] source_file
#
#   For help use: ruby_cl_skeleton -h
#
# == Options
#   -h, --help          Displays help message.
#   -v, --version       Display the version, then exit.
#   -f, --file          Absolute path of OSM file.
#   -H, --host          Host of MongoDB.
#   -p, --port          Port number of MongoDB.
#   -d, --database      Name of Database to store data.
#   -U, --url           Url Location of .osm.bz file.
#   -l, --limit         Array limit for bulk insert.
#
# == Author
#   Binh Nguyen Thai
#
# == Copyright
#   Copyright (c) 2012 Binh Nguyen Thai. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php


require 'optparse' 
require 'ostruct'
require 'date'

require_relative 'common'
require_relative 'callbacks'
require_relative 'db/classifier'


class App
  VERSION = '0.0.2'
  
  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin
    
    # Set defaults
    @options = OpenStruct.new
    # TO DO - add additional defaults
    @todos = Hash.new
  end

  # Parse options, check arguments, then process the command
  def run
        
    if parsed_options? && arguments_valid? 
      
      output_options if @options.verbose # [Optional]
            
      process_arguments
      
      collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
      common = Osm2Mongo::Common.new()
      callback = Osm2Mongo::Callbacks.new(@todos['db'], collections, Integer(@todos['limit']), common, @todos['host'], @todos['port'])
      file_path = ''
      beginning_time = Time.now
      
      if @todos.has_key?("feature") or @todos.has_key?("subfeature")
          filter = DB::Classifier.new(@todos['db'], @todos['limit'], @todos['host'], @todos['port'])
          result = 0

          if @todos.has_key?("subfeature")
              result = filter.classify_subtype(@todos['feature'], @todos['subfeature'])
          else
              result = filter.classify_all(@todos['feature'])
          end
          end_time = Time.now
          puts "\n Processed Objects :(#{result}) >>> Elapsed: #{(end_time - beginning_time)}"
          return 0
      end
      
      unless @todos.has_key?("file")
          status = common.download(@todos['url'], "/tmp/")
          status = common.decompress(status['path'])
          file_path = status['path']
      else
          file_path = @todos['file']
      end
      common.parse(file_path)
      end_time = Time.now
      puts "\nNodes:(#{callback.nodes.collection.count})  Ways:(#{callback.ways.collection.count})  Rels:(#{callback.relations.collection.count}) >>> Elapsed: #{(end_time - beginning_time)}"
      
    else
      output_usage
    end
      
  end
  
  protected
  
    def parsed_options?
      
      # Specify options
      opts = OptionParser.new 
      opts.on('-v', '--version')    { output_version ; exit 0 }
      opts.on('-h', '--help')       { output_help }
      
      opts.on('-f', '--file')       { @options.file = true }
      opts.on('-U', '--Url')        { @options.url = true}
      opts.on('-H', '--host')       { @options.host = true}
      opts.on('-p', '--port')       { @options.port = true}
      opts.on('-d', '--database')   { @options.db = true}
      opts.on('-l', '--limit')      { @options.limit = true}
      
      opts.on('-F', '--feature')    { @options.feature = true}
      opts.on('-S', '--sfeature')   { @options.subfeature = true}
      
      opts.parse!(@arguments) rescue return false

      true      
    end
    

    # True if required arguments were provided
    def arguments_valid?
      true if @arguments.length >= 5
    end
    
    # Setup the arguments
    def process_arguments

      @options.marshal_dump.each do |name, val|
        @todos[name.to_s] = ''
      end
      
      @todos.each_with_index do |(key,value), idx|
        @todos[key] = @arguments[idx]
      end

    end
    
    def output_usage
        puts "Error parsing arguments"
    end
    
    def output_version
      puts "Osm2Mongo Utility version #{VERSION}"
    end
    
end


# Create and run the application
app = App.new(ARGV, STDIN)
app.run
