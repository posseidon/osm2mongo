$LOAD_PATH << '../lib'
require 'container.rb'


describe Container, "#limit check" do
    it "should flush content and continue when limit reached" do
        con = Container.new(2, 'osm', 'node')
        [{"a" => 10}, {"b" => 20}, {"c" => 30}, {"d" => 40}, {"e" => "fika"}, {"f" => "giga"}].each do |i|
            con.add(i)
        end
        con.array.size.should == 2
    end
end

describe Container, "#database insert" do
    it "should flush content when limit reached" do
        con = Container.new(1, 'osm', 'node')
        [{"a" => 1}, {"b" => 2}, {"c" => 3}, {"d" => 4}, {"e" => "f"}, {"f" => "g"}].each do |i|
            con.add(i.to_hash)
        end
        con.flush
        con.array.size.should == 0
    end
end
