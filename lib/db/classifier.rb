require_relative 'mongohandler'

# Classifying OSM Features
# 
# Purpose:
#  Assuming you have already imported data into nodes, ways and rels collections.
#
# This class implements:
# - Dbhandler interface.
#
module DB
    class Classifier < DB::Dbhandler
        
        attr_accessor :connection
        
        COLL_WAYS = "ways"
        
        #
        # Constructor.
        # ==== Attributes
        # * +database_name+ database name
        # * +collection_name+ collection name
        # * +bulk_limit+ Array limit for bulk insert.
        # * +host+ host name (default: localhost)
        # * +port+ port number (default: 27017)    
        def initialize(database_name, bulk_limit, host, port)
            @host = host
            @port = port
            @dbname = database_name
            @bulk_limit = bulk_limit
            @data_array = Array.new
            connect()
        end

        #
        # Connecting to database
        #
        # Connecting to database with given:
        # ==== Attributes
        # * +host+ Host name
        # * +port+ Port number
        # * +pool_size+ optional
        #
        def connect
            @connection = Mongo::Connection.new(@host, @port, :pool_size => 5)
            @collection = (@connection[@dbname])[COLL_WAYS]
        end
        
        #
        # Load all features into feature_name collection.
        # ==== Attributes
        # * +feature_name+ OSM Map Feature Name
        #
        def classify_all(feature_name)
            feature_con = DB::Mongohandler.new(@dbname, feature_name, @bulk_limit, @host, @port)
            feature_con.use_connection(@connection)
            
            @collection.find("tags." << feature_name => {"$exists" => true}).each do |doc|
                feature_con.bulk_insert(doc)
            end
            return feature_con.collection.size
        end
        
        #
        # Load all features into feature_name collection with subfeature filtering.
        # ==== Attributes
        # * +feature_name+ OSM Map Feature name
        # * +sub_feature+ OSM Map Sub feature name
        #
        
        def classify_subtype(main_feature, sub_feature)
            # First argument identifies Main Feature, the rest sub-features
            feature_con = DB::Mongohandler.new(@dbname, main_feature, @bulk_limit, @host, @port)
            feature_con.use_connection(@connection)
            
            @collection.find({"tags." << main_feature => sub_feature}).each do |doc|
                feature_con.bulk_insert(doc)
            end
            return feature_con.collection.size
        end
    
        #
        # Abstract method
        #
        # Insert data:
        # ==== Attributes
        # * +data+ Hash or Array
        #    
        def insert(*args)

        end

        #
        # Abstract method
        #
        # Insert many data at once.
        # ==== Attributes
        # * +data+ Array of Hashes
        #    
        def bulk_insert(*args)

        end

    end
end