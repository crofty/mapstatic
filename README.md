# Mapstatic

A CLI and Ruby Gem for generating static maps from map tile servers.

## Requirements

1. Imagemagick

## Installation

    gem install mapstatic

## Getting started

There are two ways to generate a static map from the mapstatic CLI.

1. Specifying a bounding box and zoom level
2. Specifying a center lat, center lng, width, height and zoom level

The command below generates a map of the UK using the [OpenStreetMap](http://www.openstreetmap.org/) tileset.  The width and height of the resulting image (`uk.png`) are determined by the bounding box and the zoom level. If you don't know the bounding box of the area then [this is a useful tool](http://boundingbox.klokantech.com/).

```.bash
mapstatic map uk.png \
  --zoom=5 \
  --bbox=-11.29,49.78,2.45,58.78
```

![UK](http://matchingnotes.com/images/uk.png)

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
map = Mapstatic::Map.new(
  :zoom => 12,
  :bbox => "-0.218894,51.450943,0.014382,51.553755",
  :provider => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
)
map.render_map 'london.png'
map.metadata # Returns the map metadata
```

## License

Mapstatic is licensed under the MIT license.

See LICENSE for the full license text.
