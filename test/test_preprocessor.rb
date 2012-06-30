$LOAD_PATH << '../lib/'
require 'common'
require 'callbacks'


    describe Common, "#download" do
        it "should returns downloaded file and location" do
            common = Common.new()
            report = common.download("http://download.geofabrik.de/osm/europe/hungary.osm.bz2", "/tmp/")
            report['path'].should == "/tmp/hungary.osm.bz2"
        end
    end

    describe Common, "#decompress" do
        it "should returns downloaded file and location" do
            common = Common.new()
            result = common.decompress("/tmp/hungary.osm.bz2")
            result.should_not be(nil)
        end
    end

    describe Common, "#process map.osm" do
        it "should open and process content of osm file" do
            collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
            common = Common.new()
            callback = Callbacks.new("osm",  collections, 100, common)
            common.parse("/tmp/hungary.osm")
            (callback.parsed).should be(true)
        end
    end

