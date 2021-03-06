module Mapstatic

  class Conversion

    def lng_to_x(lng, zoom)
      n = 2 ** zoom
      ((lng.to_f + 180) / 360) * n
    end

    def x_to_lng(x, zoom)
      n = 2.0 ** zoom
      lon_deg = x / n * 360.0 - 180.0
    end

    def lat_to_y(lat, zoom)
      n = 2 ** zoom
      lat_rad = (lat / 180) * Math::PI
      (1 - Math.log( Math.tan(lat_rad) + (1 / Math.cos(lat_rad)) ) / Math::PI) / 2 * n
    end

    def y_to_lat(y, zoom)
      n = 2.0 ** zoom
      lat_rad = Math.atan(Math.sinh(Math::PI * (1 - 2 * y / n)))
      lat_deg = lat_rad / (Math::PI / 180.0)
    end
  end

end
