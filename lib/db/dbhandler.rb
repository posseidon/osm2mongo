require 'mongo'

# DBHandler: Responsible for inserting data into MongoDB
# 
# Depends:
# - mongo: Ruby Mongo Driver
#
module DBHandler
    attr_accessor :connection, :database, :collection

    #
    # Connecting to database with given:
    # ==== Attributes
    # * +database+ database name
    # * +collection+ collection name
    # * +host+ host name (default: localhost)
    # * +port+ port number (default: 27017)
    #
    def connect(database, collection, host, port)
        @connection = Mongo::Connection.new(host, port, :pool_size => 5)
        @database = @connection[database]
        @collection = @database[collection]
    end

    #
    # Connecting to database with given:
    # ==== Attributes
    # * +data+ Hash or Array
    # ==== Examples
    # insert({"key" => value})
    #    
    def insert(data)
        begin
           @collection.insert(data) 
        rescue Exception => e
            
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

        end
    end

end