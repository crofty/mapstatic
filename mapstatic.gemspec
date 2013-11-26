# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mapstatic/version"

Gem::Specification.new do |s|
  s.name        = "mapstatic"
  s.version     = Mapstatic::VERSION
  s.authors     = ["James Croft"]
  s.email       = ["james@matchingnotes.net"]
  s.homepage    = "http://matchingnotes.com"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('mini_magick', '~> 3.6.0')
  s.add_dependency('faraday', '~> 0.8.8')
  s.add_dependency('thor', '~> 0.18.1')
  s.add_dependency('awesome_print', '~> 1.2.0')
  s.add_dependency('typhoeus', '~> 0.6.6')
  s.add_development_dependency('rspec', '~> 2.13.0')
  s.add_development_dependency('vcr', '~> 2.7.0')
  s.add_development_dependency('webmock', '~> 1.15.2')
end
