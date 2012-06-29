require 'DBHandler'

# Container: Responsible for inserting data.
# 
# Purpose:
#  Ability to bulk insert data by limit set at intantiation.
#
# Depends:
# - DBHandler: Handler for MongoDB.
#
class Container
    include DBHandler
    
    #
    # Constructor.
    #
    # ==== Attributes
    # * +database+ database name.
    # * +type+ type refers to collection name, where data will be inserted.
    # * +limit+ Array limit for bulk insert.
    # * +host+ MongoDB host (default: localhost)
    # * +port+ MongoDB port (default: 27017)
    # ==== Examples
    #     container = Container.new('osm', 'nodes', 1000)
    #
    def initialize(database, type, limit, host = "localhost", port = "27017")
        # Container related initialization
        @limit = limit
        @array = Array.new
        
        # MongoDB related initialization
        connect(database, type, host, port)
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
        if (@array.size >= @limit)
            bulk_insert(@array)
            @array.clear
            @array.push(data)
        else
            @array.push(data)
        end
    end
    
    #
    # Insert remaining data in Array and close Database connection.
    #
    def flush
        # Push remaining data to database
        bulk_insert(@array)
        # Clear Hash Array
        @array.clear
        # Close Database connection.
        close()
    end        
end

