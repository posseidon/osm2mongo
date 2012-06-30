$LOAD_PATH << '../lib/'
require 'common'
require 'callbacks'


    describe Osm2Mongo::Common, "#download" do
        it "should returns downloaded file and location" do
            common = Osm2Mongo::Common.new()
            report = common.download("http://download.geofabrik.de/osm/europe/hungary.osm.bz2", "/tmp/")
            report['path'].should == "/tmp/hungary.osm.bz2"
        end
    end

    describe Osm2Mongo::Common, "#decompress" do
        it "should returns downloaded file and location" do
            common = Osm2Mongo::Common.new()
            result = common.decompress("/tmp/hungary.osm.bz2")
            result.should_not be(nil)
        end
    end

    describe Osm2Mongo::Common, "#process map.osm" do
        it "should open and process content of osm file" do
            collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
            common = Osm2Mongo::Common.new()
            callback = Osm2Mongo::Callbacks.new("osm",  collections, 100, common, 'localhost', '27017')
            common.parse("/tmp/hungary.osm")
            (callback.parsed).should be(true)
        end
    end

