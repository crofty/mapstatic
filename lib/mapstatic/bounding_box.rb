module Mapstatic
  class BoundingBox
    attr_accessor :left, :right, :top, :bottom

    def initialize(params={})
      @left = params.fetch(:left)
      @bottom = params.fetch(:bottom)
      @right = params.fetch(:right)
      @top = params.fetch(:top)
    end

    def to_a
      [left, bottom, right, top]
    end
    alias_method :to_latlng_coordinates, :to_a

    def to_xy_coordinates(zoom)
      [
        Conversion.lng_to_x(left, zoom),
        Conversion.lat_to_y(bottom, zoom),
        Conversion.lng_to_x(right, zoom),
        Conversion.lat_to_y(top, zoom)
      ]
    end

    def center
      lat = (bottom + top) / 2
      lng = (left + right) / 2

      {lat: lat, lng: lng}
    end

    def center=(lat:, lng:)
      delta_lat = lat - center[:lat]
      delta_lng = lng - center[:lng]

      @left   += delta_lng
      @bottom += delta_lat
      @right  += delta_lng
      @top    += delta_lat
    end

    def width_at(zoom)
      delta = Conversion.lng_to_x(right, zoom) - Conversion.lng_to_x(left, zoom)
      (delta * Map::TILE_SIZE).abs
    end

    def height_at(zoom)
      delta = Conversion.lat_to_y(top, zoom) - Conversion.lat_to_y(bottom, zoom)
      (delta * Map::TILE_SIZE).abs
    end

    def fits_in?(other)
      left >= other.left and right <= other.right and top <= other.top and bottom >= other.bottom
    end

    def contains?(other)
      other.fits_in? self
    end

    def set_to(other)
      @left   = other.left
      @right  = other.right
      @top    = other.top
      @bottom = other.bottom
    end

    def self.for(coordinates)
      lngs = coordinates.map {|point| point[0]}
      lats = coordinates.map {|point| point[1]}

      left   = lngs.min
      bottom = lats.min
      right  = lngs.max
      top    = lats.max

      BoundingBox.new top: top, bottom: bottom, left: left, right: right
    end

    def self.from(center_lat:, center_lng:, width:, height:, zoom:)
      x = Conversion.lng_to_x(center_lng, zoom)
      y = Conversion.lat_to_y(center_lat, zoom)

      left      = Conversion.x_to_lng( x - ( width / 2 ), zoom)
      right     = Conversion.x_to_lng( x + ( width / 2 ), zoom)
      bottom    = Conversion.y_to_lat( y + ( height / 2 ), zoom)
      top       = Conversion.y_to_lat( y - ( height / 2 ), zoom)

      BoundingBox.new top: top, bottom: bottom, left: left, right: right
    end
  end
end
