require 'mapstatic'
require 'mapstatic/gpx_file'
require 'awesome_print'
require 'thor'
require 'json'

class Mapstatic::CLI < Thor

  desc "map FILENAME", "Generate a map"
  long_desc <<-LONGDESC
     `mapstatic map FILENAME` will create a new static map.

     A map can be created in two ways:

     1. With a bounding box, e.g.

     $ mapstatic map uk.png --zoom=6 --bbox=-10.93,49.64,3.15,59.57

     When creating a map with a bounding box, the width and height of the map
     will be determined by the zoom level.

     2. With a center lat, lng, width and height, e.g.

     $ mapstatic map greenwich.png --zoom=12 \
                                   --lat=51.477222 \
                                   --lng=0 \
                                   --width=700 \
                                   --height=700

     By default, the map will be generated with the OpenStreetMap tile set (Copyright
     OpenStreetMap contributors).

     You can generate a map using any tile set by passing the --provider option.

     To draw a gpx track on top of the map, you can pass a file with --gpx:

     $ mapstatic map uk.png --zoom=6 --width=320 --height=290 --gpx=file.gpx
  LONGDESC

  option :zoom
  option :provider, :default => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  option :bbox
  option :lat
  option :lng
  option :width,  :default => 256
  option :height, :default => 256
  option :gpx
  option :dryrun, :type => :boolean, :default => false

  def map(filename)
    params = Hash[options.map{|(k,v)| [k.to_sym,v]}]

    if params[:bbox]
      bbox = params[:bbox].split(",").map { |c| c.to_f }
      params[:bbox] = bbox
    end

    map = Mapstatic::Map.new(params)

    if options[:gpx]
      gpx_file = Mapstatic::GpxFile.new options[:gpx]
      geojson_data = gpx_file.geojson_data

      # Drawing only one geojson feature is supported at the moment. So just pick
      # the first one on the file.
      first_track = geojson_data[:features].first
      map.geojson = first_track
      map.fit_bounds
    end

    map.render_map(filename) unless options[:dryrun]

    metadata = {
      map_bbox: map.viewport.to_a.join(','),
      width: map.width.to_i,
      height: map.height.to_i,
      zoom: map.zoom
    }

    ap metadata
  end

end
