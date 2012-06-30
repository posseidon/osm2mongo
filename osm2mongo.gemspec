require 'lib/reverser/version'
spec = Gem::Specification.new do |s|
  s.name = 'osm2mongo' # the name of your library
  s.author = 'Binh Nguen Thai' # your name
  s.add_development_dependency('rspec') # development dependency
  s.add_dependency 'nokogiri'
  s.add_dependency 'mongo'
  s.add_dependency 'progressbar' # dependency
  s.description = 'Parse Openstreetmap OSM file format and store it in MongoDB'
  s.email = 'posseidon@gmail.com' # your email address
  s.files = Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/posseidon/osm2mongo'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.summary = 'OSM into MongoDB'
  s.test_files = Dir.glob('test/*.rb')
  s.version = Osm2Mongo::VERSION
  s.rubyforge_project = "osm2mongo" # what rubygems will call this gem
end
