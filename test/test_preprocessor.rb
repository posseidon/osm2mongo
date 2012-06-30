$LOAD_PATH << '../lib'
require 'Common'


    describe Common, "#download" do
        it "should returns downloaded file and location" do
            #report = Common.download("http://download.geofabrik.de/osm/europe/hungary.osm.bz2", "/tmp/")
            #report['path'].should == "/tmp/map.osm.bz2"
        end
    end

    describe Common, "#decompress" do
        it "should returns downloaded file and location" do
            result = Common.decompress("/tmp/map.osm.bz2")
            result.should_not be(nil)
        end
    end

    describe Common, "#process map.osm" do
        it "should open and process content of osm file" do
            collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
            status = Common.push2mongo("/tmp/map.osm", "osm",  collections, 1000)
            status.should_not be(nil)
        end
    end

