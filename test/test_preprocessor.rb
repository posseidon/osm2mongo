# bowling_spec.rb
require '../lib/preprocessor.rb'

describe Preprocessor, "#download" do
    it "should returns downloaded file and location" do
        report = Preprocessor.download("http://download.geofabrik.de/osm/europe/hungary.osm.bz2", "/tmp/")
        report['path'].should == "/tmp/hungary.osm.bz2"
    end
end

describe Preprocessor, "#download" do
    it "should returns downloaded file and location" do
        report = Preprocessor.extract("/tmp/hungary.osm.bz2")
        report['path'].should == "/tmp/hungary.osm"
    end
end


