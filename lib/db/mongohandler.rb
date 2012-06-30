require_relative 'dbhandler'
require 'mongo'

module DB
    class Mongohandler < DB::Dbhandler
        attr_accessor :connection, :collection, :host, :port
        attr_accessor :data_array

        #
        # Constructor.
        # ==== Attributes
        # * +database_name+ database name
        # * +collection_name+ collection name
        # * +bulk_limit+ Array limit for bulk insert.
        # * +host+ host name (default: localhost)
        # * +port+ port number (default: 27017)    
        def initialize(database_name, collection_name, bulk_limit, host = "localhost", port = "27017")
            @host = host
            @port = port
            @dbname = database_name
            @collname = collection_name
            @bulk_limit = bulk_limit
            @data_array = Array.new
            @collections = Hash.new
        end

        #
        # Connecting to Mongo database.
        #
        def connect
            @connection = Mongo::Connection.new(@host, @port, :pool_size => 5)
            @collection = (@connection[@dbname])[@collname]
        end

        #
        # Insert data.
        # ==== Attributes
        # * +data+ Hash or Array
        # ==== Examples
        # insert({"key" => value})
        #    
        def insert(data)
            begin
               @collection.insert(data) 
            rescue Exception => e
                puts e
            end
        end
    
        #
        # Insert at once many data.
        # ==== Attributes
        # * +data+ Array of Hashes
        # bulk_insert([{"key" => value},{"another_key" => another_value}])
        #
        def bulk_insert(data)
            begin
               @collection.insert(data)
            rescue Exception => e
                puts e
            end
        end
    
        #
        # Insert data into Data Array.
        # 
        # Purpose:
        #  When limit reached DBHandler::bulk_insert will be called on data array.
        #
        # ==== Attributes
        # * +data+ Hash or Array
        #    
        def add(data)
            if (@data_array.size >= @bulk_limit)
                bulk_insert(@data_array)
                @data_array.clear
                @data_array.push(data)
            else
                @data_array.push(data)
            end
        end
    
        #
        # Insert remaining data in Array and close Database connection.
        #    
        def flush
            # Push remaining data to database
            bulk_insert(@array)
            # Clear Hash Array
            @data_array.clear
            # Close Database connection.
            @connection.close()
        end
    end
end