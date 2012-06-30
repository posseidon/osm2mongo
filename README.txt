= osm2mongo

* https://github.com/posseidon/osm2mongo

== DESCRIPTION:

Import Openstreetmap .osm(xml) data format into MongoDB written in Ruby.

== FEATURES/PROBLEMS:

* TODO: Missing Rake task for installing dependencies and generate documentation.

== SYNOPSIS:

  From Code:
  =============
  
  collections = {"node" => "nodes", "way" => "ways", "relation" => "rels"}
  common = Osm2Mongo::Common.new()
  status = common.download("http://download.geofabrik.de/osm/europe/hungary.osm.bz2", "/tmp/")
  status = common.decompress(status['path'])
  callback = Osm2Mongo::Callbacks.new("osm",  collections, 100, common)
  common.parse(status['path'])
  
  From command line:
  =============
  
  ruby osm2mongo.rb -H localhost -p 27017 -d osm -l 200 -f /tmp/map.osm
  ruby osm2mongo.rb -H localhost -p 27017 -d osm -l 200 -U http://people.inf.elte.hu/ntb/map.osm.bz2


== REQUIREMENTS:

* mongo: MongoDB ruby driver (http://rubygems.org/gems/mongo)
* nokogiri: xml parser (http://rubygems.org/gems/nokogiri)
* progressbar: just for fun and icandy :-) (http://rubygems.org/gems/progressbar)

== INSTALL:

sudo gem install osm2mongo

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2012 OSM2Mongo

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
