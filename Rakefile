require "rubygems"
require "rubygems/package_task"
require "rdoc/task"
$:.push File.expand_path("../lib", __FILE__)
require "mapstatic/version"

require "rspec"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(--format documentation --colour)
end

task :default => ["spec"]

spec = Gem::Specification.new do |s|
  s.name              = "mapstatic"
  s.version           = Mapstatic::VERSION
  s.summary           = "Static Map Generator"
  s.authors           = ["James Croft", "Mika Haulo", "Tim Neems", "Olli Huotari", "Michael O'Toole"]
  s.email             = "james@matchingnotes.com"
  s.homepage          = "https://github.com/crofty/mapstatic"
  s.license           = "MIT"

  s.files             = %w(Gemfile Gemfile.lock) + Dir.glob("{spec,lib}/**/*")
  s.require_paths     = ["lib"]
  s.executables << 'mapstatic'

  s.add_dependency('mini_magick', '~> 4.9')
  s.add_dependency('typhoeus', '~> 1.3')
  s.add_dependency('nokogiri', '~> 1.10')

  s.add_development_dependency('rake', '~> 12') # needed so that 'bundle exec rake' will work as expected
  s.add_development_dependency('rspec', '~> 3')
  s.add_development_dependency('vcr', '~> 3')
  s.add_development_dependency('webmock', '~> 2')

  # install these if you want to use command line env
  s.add_development_dependency('thor', ['>= 0.19.0', '< 2.0'])
  s.add_development_dependency('awesome_print', '< 2.0') 
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more 
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task :package => :gemspec

# Generate documentation
RDoc::Task.new do |rd|
  
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
