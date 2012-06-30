$LOAD_PATH << '../lib/db'
require 'mongohandler.rb'


describe DB::Mongohandler, "#connect" do
    it "should returns connection status active" do
        mongo = DB::Mongohandler.new("local", "test", 100, 'localhost', '27017')
        mongo.connect()
        (mongo.connection.connected?).should be(true)
    end
end

describe DB::Mongohandler do
    before do
        @handler = DB::Mongohandler.new("local", "test", 100, 'localhost', '27017')
        @handler.connect()
    end
    
    it "should insert a single document" do
        @handler.insert({"test" => "data"})
        (@handler.collection.count).should be(1)
    end

    it "should insert at least one document" do
        @handler.bulk_insert([{"test" => "data"}, {"another_test" => "another_data"}])
        (@handler.collection.count).should be(2)
    end
    
    
    after do
        @handler.collection.drop()
    end
end
