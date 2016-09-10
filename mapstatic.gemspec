# -*- encoding: utf-8 -*-
# stub: mapstatic 0.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "mapstatic"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James Croft"]
  s.date = "2016-09-10"
  s.email = "james@matchingnotes.com"
  s.executables = ["mapstatic"]
  s.files = ["Gemfile", "Gemfile.lock", "bin/mapstatic", "lib/mapstatic", "lib/mapstatic.rb", "lib/mapstatic/cli.rb", "lib/mapstatic/conversion.rb", "lib/mapstatic/errors.rb", "lib/mapstatic/map.rb", "lib/mapstatic/tile.rb", "lib/mapstatic/tile_source.rb", "lib/mapstatic/version.rb", "spec/fixtures", "spec/fixtures/maps", "spec/fixtures/maps/london.png", "spec/fixtures/maps/thames.png", "spec/fixtures/vcr_cassettes", "spec/fixtures/vcr_cassettes/osm-london-fail.yml", "spec/fixtures/vcr_cassettes/osm-london.yml", "spec/fixtures/vcr_cassettes/osm-thames.yml", "spec/models", "spec/models/map_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/crofty/mapstatic"
  s.rubygems_version = "2.5.1"
  s.summary = "Static Map Generator"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mini_magick>, ["~> 4.0"])
      s.add_runtime_dependency(%q<typhoeus>, ["~> 1.0"])
      s.add_development_dependency(%q<thor>, ["~> 0.18.1"])
      s.add_development_dependency(%q<awesome_print>, ["~> 1.2.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_development_dependency(%q<vcr>, ["~> 2.7.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.15.2"])
    else
      s.add_dependency(%q<mini_magick>, ["~> 4.0"])
      s.add_dependency(%q<typhoeus>, ["~> 1.0"])
      s.add_dependency(%q<thor>, ["~> 0.18.1"])
      s.add_dependency(%q<awesome_print>, ["~> 1.2.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_dependency(%q<vcr>, ["~> 2.7.0"])
      s.add_dependency(%q<webmock>, ["~> 1.15.2"])
    end
  else
    s.add_dependency(%q<mini_magick>, ["~> 4.0"])
    s.add_dependency(%q<typhoeus>, ["~> 1.0"])
    s.add_dependency(%q<thor>, ["~> 0.18.1"])
    s.add_dependency(%q<awesome_print>, ["~> 1.2.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.13.0"])
    s.add_dependency(%q<vcr>, ["~> 2.7.0"])
    s.add_dependency(%q<webmock>, ["~> 1.15.2"])
  end
end
