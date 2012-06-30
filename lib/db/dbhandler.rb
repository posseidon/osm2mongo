require_relative 'abstract_interface'

module DB
    class Dbhandler
        include AbstractInterface
    
        #
        # Abstract method
        #
        # Connecting to database with given:
        # ==== Attributes
        # * +args+ optional: host, port, database name
        #
        def connect(*args)
            Dbhandler.api_not_implemented(self)
        end
    
        #
        # Abstract method
        #
        # Insert data:
        # ==== Attributes
        # * +data+ Hash or Array
        #    
        def insert(*args)
            Dbhandler.api_not_implemented(self)
        end

        #
        # Abstract method
        #
        # Insert many data at once.
        # ==== Attributes
        # * +data+ Array of Hashes
        #    
        def bulk_insert(*args)
            Dbhandler.api_not_implemented(self)
        end
    end
end
