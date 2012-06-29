#!/usr/bin/env ruby
$LOAD_PATH << '../lib'
require 'dbhandler.rb'


describe DBHandler, "#connect" do
    it "should returns connection status" do
        (DBHandler.connect('osm')).should be_an_instance_of(Mongo::DB)
        DBHandler.close()
    end
end
