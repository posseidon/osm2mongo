require_relative 'db/mongohandler'

module Osm2Mongo
    # Container: Responsible for inserting data.
    # 
    # Purpose:
    #  Ability to bulk insert data by limit set at intantiation.
    #
    # Depends:
    # - Container: Handler for MongoDB.
    #
    class Callbacks
        NODE = "node"
        WAY = "way"
        RELATION = "relation"
        TAG = "tag"
        TEXT = "#text"
        NODEREF = "nd"
        MEMBER = "member"
    
        NDS = "nodes"
        TGS = "tags"
        MBS = "members"
        DONE = "done"
    
        KEY = "k"
        VALUE = "v"
        ID = "id"
        MID = "_id"
        LON = "lon"
        LAT = "lat"
        REF = "ref"
    
        attr_accessor :parsed
        attr_accessor :nodes, :ways, :relations
    
        def initialize(database, collections, qlimit, parser, host, port)
            @nodes = DB::Mongohandler.new(database, collections[NODE], qlimit, host, port)
            @nodes.connect()
        
            @ways = DB::Mongohandler.new(database, collections[WAY], qlimit, host, port)
            @ways.use_connection(@nodes.connection)
        
            @relations = DB::Mongohandler.new(database, collections[RELATION], qlimit, host, port)
            @relations.use_connection(@nodes.connection)
        
            parser.add_observer(self)
            @parsed = false
        end
    
        def update(reader)
            case reader.name
                when NODE
                    node(reader)
                when WAY
                    way(reader)
                when RELATION
                    relation(reader)
                when DONE
                    flush_all()
                else
                    # Skip
            end
        end
    
        def flush_all
            @nodes.flush()
            @ways.flush()
            @relations.flush()
            @parsed = true
        end

        def node(reader)
            attributes = {MID => reader.attribute(ID), LON => reader.attribute(LON), LAT => reader.attribute(LAT)}
            unless reader.empty_element?
                extract_children(reader, attributes)
            end
            @nodes.add(attributes)
        end

        def way(reader)
            attributes = {MID => reader.attribute(ID)}
            unless reader.empty_element?
                extract_children(reader, attributes)
            end
            @ways.add(attributes)
        end

        def relation(reader)
            attributes = {MID => reader.attribute(ID)}
            unless reader.empty_element?
                extract_children(reader, attributes)
            end
            @relations.add(attributes)
        end
    
        private
        def extract_children(node, attributes)
            nodes = []
            members = []
            tags = Hash.new
            begin
                node.read()
                if (node.name == TAG )
                    tags[node.attribute(KEY)] = node.attribute(VALUE)
                elsif (node.name == NODEREF)
                    nodes.push(node.attribute(REF))
                elsif (node.name == MEMBER)
                    members.push(node.attributes)
                else
                    # Unknown sequence
                end            
            end while(node.name == TAG or node.name == NODEREF or node.name == MEMBER or node.name == TEXT)

            attributes[TGS] = tags unless tags.empty?
            attributes[NDS] = nodes unless nodes.size < 1
            attributes[MBS] = members unless members.size < 1
        end
    end
end