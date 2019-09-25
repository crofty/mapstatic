module Mapstatic

  def self.options
    @options ||= {
        :typhoeus_options => {:timeout => 10, :followlocation => true, :maxredirs => 10, :headers => {"User-Agent" => "Mapstatic using typhoeus"} }
    }
  end

end

require 'mapstatic/errors'
require 'mapstatic/version'
require 'mapstatic/conversion'
require 'mapstatic/bounding_box'
require 'mapstatic/map'
require 'mapstatic/tile'
require 'mapstatic/tile_source'
require 'mapstatic/renderer'
require 'mapstatic/painter'
require 'mapstatic/painter/null_painter'
require 'mapstatic/painter/line_string_painter'
