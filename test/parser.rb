require 'xml'

READ = "r"


    reader = XML::Reader.file("/tmp/map.osm")
    while reader.read
        puts reader.node_type

    end


