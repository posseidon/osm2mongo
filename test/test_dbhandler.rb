$LOAD_PATH << '../lib'
require 'DBHandler'


class TestDbhandler
    include DBHandler
    
    def initialize(db_name = 'local', coll_name = 'test', host = 'localhost', port = '27017')
        connect(db_name, coll_name, host, port)
    end
    
    
end


describe DBHandler, "#initialize" do
    it "should create new TestDbHandler" do
        handler = TestDbhandler.new
        handler.should be_a_kind_of(DBHandler)
    end
end

describe DBHandler, "#initialize connection" do
    it "should create new TestDbHandler with default local database" do
        handler = TestDbhandler.new('local', 'test')
        (handler.connection.connected?).should be(true)
    end
end

describe DBHandler do
    before do
        @handler = TestDbhandler.new('local', 'test')
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
