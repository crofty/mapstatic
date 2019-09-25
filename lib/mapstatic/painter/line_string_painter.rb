module Mapstatic
  class Painter::LineStringPainter < Painter
    def self.accept?(geometry_type)
      geometry_type == "LineString"
    end

    def paint_to(image, viewport)
      # Convert coordinates to the corresponding pixel locations on
      # image canvas.
      # This is a two step process:
      # 1. Convert latlng-coordinates to pixel-coordinates.
      # 2. Convert pixel coordinates from Earth perspective to image perspective.
      # All conversions require the zoom level we're working on, but the second step
      # also requires a new reference, which is the image bounding box (calculated above).
      # Also be careful when working on latlng-coordinates in array form - make sure
      # which order they are in.

      coordinates = feature["geometry"]["coordinates"]

      xy_points = coordinates.map do |coordinate|
        px = Conversion.x_to_px(
            Conversion.lng_to_x(coordinate[0], map.zoom),
            Conversion.lng_to_x(viewport.center[:lng], map.zoom),
            viewport.width_at(map.zoom),
            Map::TILE_SIZE
        )

        py = Conversion.y_to_px(
            Conversion.lat_to_y(coordinate[1], map.zoom),
            Conversion.lat_to_y(viewport.center[:lat], map.zoom),
            viewport.height_at(map.zoom),
            Map::TILE_SIZE
        )

        "#{px},#{py}"
      end

      image.combine_options do |c|
        c.fill "none"
        c.stroke stroke_color
        c.strokewidth stroke_width
        c.draw "polyline #{xy_points.join(" ").strip}"
      end

      image
    end
  end
end
