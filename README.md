# Mapstatic

A CLI and Ruby Gem for generating static maps from map tile servers.

## Requirements

1. Ruby (on linux you may need the ruby-dev package)
2. Imagemagick

## Installation

    gem install mapstatic

if you want to use command line for creating maps then additional gems are required

    gem install mapstatic
    gem install thor
    gem install awesome_print

## Getting started

There are two ways to generate a static map from the mapstatic CLI.

1. Specifying a bounding box and zoom level

  The command below generates a map of the UK using the [OpenStreetMap](http://www.openstreetmap.org/) tileset.  The width and height of the resulting image (`uk.png`) are determined by the bounding box and the zoom level. If you don't know the bounding box of the area then [this is a useful tool](http://boundingbox.klokantech.com/).  

  ```.bash
  mapstatic map uk.png \
    --zoom=5 \
    --  bbox=-11.29,49.78,2.45,58.78
  ```  

  ![UK](http://matchingnotes.com/images/uk.png)

2. Specifying a center lat, center lng, width, height and zoom level

  Alternatively, you can specify a central latitude and longitude and specify the width and height.  

  ```.bash
  mapstatic map silicon-roundabout.png \
    --zoom=18 \
    --lat=51.52567 \
    --lng=-0.08750 \
    --width=600 \
    --height=300
  ```  

![Silicon Roundabout](http://matchingnotes.com/images/silicon-roundabout.png)

Optionally a gpx file can be specified. In that case, the routes and tracks contained in that file will be drawn on top of the map. The map view will be automatically adjusted to fit the given gpx route data.

```.bash
mapstatic map map.png \
  --zoom=12 \
  --width=600 \
  --height=300 \
  --gpx=file.gpx
```

## Changing the provider

Mapstatic can generate maps from any slippy map tile server. The tile provider can be specified with a URL template

```.bash
mapstatic map uk.png \
  --zoom=5 \
  --bbox=-11.29,49.78,2.45,58.78 \
  --provider=http://{s}.example.com/{z}/{x}/{y}.png
```

`{s}` is subdomain, `{z}` zoom level, `{x}` and `{y}` are tile coordinates.

If no tile server is specified, then the [OpenStreetMap](http://www.openstreetmap.org/) tile set will be used.

## Map Metadata

After generating a map, Mapstatic will print metadata about the map to the console.  If you only want to see this metadata and don't want to actually generate the map, you can use the `dryrun` flag

```.bash
$ mapstatic map uk.png \
>   --zoom=5 \
>   --bbox=-11.29,49.78,2.45,58.78 \
>   --dryrun=true
{
              :bbox => "-11.29,49.78,2.45,58.78",
              :width => 312,
            :height => 352,
              :zoom => 5,
    :number_of_tiles => 6
}
```

This is useful for seeing how large your map will be, and how many tiles it will be using without actually generating your map.

## Ruby API

Mapstatic can be used in your application code to generate maps and get metadata about them:

```.ruby
require 'mapstatic'

# Initialize
map = Mapstatic::Map.new(
  width: 400,
  height: 200
  zoom: 11,
  provider: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
)

# optional: set geojson data layer
geojson_data = {
  type: "FeatureCollection",
  features: ... # Currently only LineString is supported by Mapstatic
}
map.geojson = geojson_data
map.fit_bounds # Call this to set map dimensions so that geojson data fits into map area

# Render to file
map.to_file 'london.png'
map.metadata # Returns the map metadata

# You can also just render the image without writing it to a file.
# This will produce a MiniMagic image object.
image = map.to_image
```

### Supported GeoJSON feature types

* LineString

To add support for more types, inherit a new class from Mapstatic::Painter, implement required methods, and add the class to painter_class_for method in `renderer.rb`.

## License

Mapstatic is licensed under the MIT license.

See LICENSE for the full license text.
