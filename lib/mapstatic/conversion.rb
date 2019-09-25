module Mapstatic
  class Conversion
    def self.lng_to_x(lng, zoom)
      n = 2 ** zoom
      ((lng.to_f + 180) / 360) * n
    end

    def self.x_to_lng(x, zoom)
      n = 2.0 ** zoom
      lon_deg = x / n * 360.0 - 180.0
    end

    def self.lat_to_y(lat, zoom)
      n = 2 ** zoom
      lat_rad = (lat / 180) * Math::PI
      (1 - Math.log( Math.tan(lat_rad) + (1 / Math.cos(lat_rad)) ) / Math::PI) / 2 * n
    end

    def self.y_to_lat(y, zoom)
      n = 2.0 ** zoom
      lat_rad = Math.atan(Math.sinh(Math::PI * (1 - 2 * y / n)))
      lat_deg = lat_rad / (Math::PI / 180.0)
    end

    # Convert pixel coordinate x from Earth perspective (i.e the reference point, or the 0 value
    # is at the prime meridian) to image perspective. The zero point of the image depends on its
    # bounding box.
    def self.x_to_px(x, bbox_center_x, bbox_width, tile_size)
      px = (x - bbox_center_x) * tile_size + bbox_width / 2
      px.round
    end

    # Convert pixel coordinate y from Earth perspective (i.e the reference point, or the 0 value
    # is at the equator) to image perspective. The zero point of the image depends on its
    # bounding box.
    def self.y_to_px(y, bbox_center_y, bbox_height, tile_size)
      px = (y - bbox_center_y) * tile_size + bbox_height / 2
      px.round
    end
  end
end
