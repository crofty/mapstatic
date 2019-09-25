module Mapstatic
  class Renderer
    def initialize(map)
      @map = map
    end

    def render
      fetch_tiles
      create_uncropped_image
      fill_image_with_tiles
      draw_geometry if @map.geojson
      crop_to_size
      @image
    end

    def render_to(filename)
      render.write filename
    end

    private

    def fetch_tiles
      @tiles = @map.tile_source.get_tiles(required_tiles)
    end

    def required_tiles
      required_y_tiles.map do |y|
        required_x_tiles.map{|x| Tile.new(x, y, @map.zoom) }
      end.flatten
    end

    def required_x_tiles
      left, bottom, right, top = @map.viewport.to_xy_coordinates(@map.zoom)
      Range.new(*[left, right].map(&:floor).sort).to_a
    end

    def required_y_tiles
      left, bottom, right, top = @map.viewport.to_xy_coordinates(@map.zoom)
      Range.new(*[bottom, top].map(&:floor).sort).to_a
    end

    def create_uncropped_image
      @image = MiniMagick::Image.read(@tiles[0])

      uncropped_width  = required_x_tiles.length * Map::TILE_SIZE
      uncropped_height = required_y_tiles.length * Map::TILE_SIZE

      @image.combine_options do |c|
        c.background 'none'
        c.extent [uncropped_width, uncropped_height].join('x')
      end
    end

    def fill_image_with_tiles
      start = 0

      required_y_tiles.length.times do |row|
        length = required_x_tiles.length

        @tiles.slice(start, length).each_with_index do |tile, column|
          @image = @image.composite( MiniMagick::Image.read(tile) ) do |c|
            c.geometry "+#{ (column) * Map::TILE_SIZE }+#{ (row) * Map::TILE_SIZE }"
          end
        end

        start += length
      end
    end

    def draw_geometry
      if @map.geojson["type"] == "Feature"
        features = [@map.geojson]
      elsif @map.geojson["type"] == "FeatureCollection"
        features = @map.geojson["features"]
      end

      left = Conversion.x_to_lng(required_x_tiles.first, @map.zoom)
      top  = Conversion.y_to_lat(required_y_tiles.first, @map.zoom)

      # The +1s here are for getting the bottom right location for each tile - the tile
      # number itself points to the top left corner.
      right  = Conversion.x_to_lng(required_x_tiles.last+1, @map.zoom)
      bottom = Conversion.y_to_lat(required_y_tiles.last+1, @map.zoom)

      uncropped_viewport = BoundingBox.new left: left, bottom: bottom, right: right, top: top

      features&.each do |feature|
        painter_for(feature).paint_to(@image, uncropped_viewport)
      end
    end

    def crop_to_size
      distance_from_left = (@map.viewport.to_xy_coordinates(@map.zoom)[0] - required_x_tiles[0]) * Map::TILE_SIZE
      distance_from_top  = (@map.viewport.to_xy_coordinates(@map.zoom)[3] - required_y_tiles[0]) * Map::TILE_SIZE

      @image.crop "#{@map.width}x#{@map.height}+#{distance_from_left}+#{distance_from_top}"
    end

     def painter_for(feature)
      painter_class_for(feature["geometry"]["type"]).new(map: @map, feature: feature)
    end

    def painter_class_for(feature_type)
      # To add more painters, inherit a new class from Mapstatic::Painter, implement
      # required methods, and add the class to this array.
      painters = [Painter::LineStringPainter]
      painter_class = painters.detect {|klass| klass.accept? feature_type} || Painter::NullPainter
    end
  end
end
