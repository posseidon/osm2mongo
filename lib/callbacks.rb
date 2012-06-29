require 'Container'

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
    
    KEY = "k"
    VALUE = "v"
    ID = "id"
    MID = "_id"
    LON = "lon"
    LAT = "lat"
    REF = "ref"
    
    def initialize(database, collections, qlimit)
        @nodes = Container.new(database, collections[NODE], qlimit)
        @ways = Container.new(database, collections[WAY], qlimit)
        @relations = Container.new(database, collections[RELATION], qlimit)
    end
    
    def called(reader)
        case reader.name
            when NODE
                node(reader)
            when WAY
                way(reader)
            when RELATION
                relation(reader)
            else
                # Skip
        end
    end
    
    def end
        @nodes.flush()
        @ways.flush()
        @relations.flush()
        return {NODE => @nodes.collection.count, WAY => @ways.collection.count, RELATION => @relations.collection.count}
    end

    def node(reader)
        attributes = {MID => reader.attribute(ID), LON => reader.attribute(LON), LAT => reader.attribute(LAT)}
        unless reader.empty_element?
            extract_children(reader, attributes)
        end
        #puts attributes.to_json
        @nodes.add(attributes)
    end

    def way(reader)
        attributes = {MID => reader.attribute(ID)}
        unless reader.empty_element?
            extract_children(reader, attributes)
        end
        #puts attributes.to_json
        @ways.add(attributes)
    end

    def relation(reader)
        attributes = {MID => reader.attribute(ID)}
        unless reader.empty_element?
            extract_children(reader, attributes)
        end
        #puts attributes.to_json
        #ways.add(attributes)

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