# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'rubygems/dependency_installer.rb'

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rubyforge

Hoe.spec 'osm2mongo' do
  # HEY! If you fill these out in ~/.hoe_template/Rakefile.erb then
  # you'll never have to touch them again!
  # (delete this comment too, of course)

  developer('Binh Nguyen Thai', 'posseidon@gmail.com')

  # self.rubyforge_name = 'osm2mongo' # if different than 'osm2mongo'
end

# vim: syntax=ruby

inst = Gem::DependencyInstaller.new
    begin
     inst.install "progressbar"
     inst.install "nokogiri"
     inst.install "mongo"
    rescue
     exit(1)
    end
