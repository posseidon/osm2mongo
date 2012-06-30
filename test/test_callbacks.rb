$LOAD_PATH << '../lib'
require 'callbacks.rb'
require 'observer'

class TestCallbacks
    include Observable
    
    INFO = Struct.new(:name)
    
    def publish
        changed()
        notify_observers(INFO.new("done"))
    end
end


describe Callbacks, "#test Observer" do
    it "should open and process content of osm file" do
        test = TestCallbacks.new
        collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
        callback = Callbacks.new("osm",  collections, 1000, test)
        test.publish()
        (callback.parsed).should be(true)
    end
end
