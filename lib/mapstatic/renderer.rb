module Mapstatic
  class Renderer
    def initialize(map)
      @map = map
    end

    def render
      fetch_tiles
      create_uncropped_image
      fill_image_with_tiles
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

    def crop_to_size
      distance_from_left = (@map.viewport.to_xy_coordinates(@map.zoom)[0] - required_x_tiles[0]) * Map::TILE_SIZE
      distance_from_top  = (@map.viewport.to_xy_coordinates(@map.zoom)[3] - required_y_tiles[0]) * Map::TILE_SIZE

      @image.crop "#{@map.width}x#{@map.height}+#{distance_from_left}+#{distance_from_top}"
    end
  end
end
