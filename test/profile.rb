require 'ruby-prof'
$LOAD_PATH << '../lib'
require 'preprocessor.rb'

# Profile the code
RubyProf.start

status = Preprocessor.push2mongo"/tmp/map.osm")

result = RubyProf.stop

# Print a flat profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)