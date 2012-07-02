$LOAD_PATH << '../lib/db'
require 'classifier.rb'


describe DB::Classifier, "#connect" do
    it "should returns connection status active" do
        mongo = DB::Classifier.new("osm", 100, 'localhost', '27017')
        (mongo.connection.connected?).should be(true)
    end
end


describe DB::Classifier do
    before do
        @handler = DB::Classifier.new("osm", 100, 'localhost', '27017')
    end
    
    it "should insert documents by given feature type" do
        result = @handler.classify_all("highway")
        result.should be > 0
    end

    it "should insert documents by given feature-sub-feature type" do
        result = @handler.classify_subtype("waterway", "riverbank")
        result.should be > 0
    end
    
    
    after do
        #@handler.collection.drop()
    end
end
