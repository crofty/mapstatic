module Mapstatic
  class Painter
    attr_reader :feature
    attr_reader :map
    attr_accessor :stroke_width
    attr_accessor :stroke_color

    # Implement this method in a subclass.
    def self.accept?(geometry_type)
      false
    end

    def initialize(params={})
      @map = params.fetch(:map)
      @feature = params.fetch(:feature)
      @stroke_color = params.fetch(:stroke_color, "rgb(51, 136, 255)")
      @stroke_width = params.fetch(:stroke_width, 4)
    end

    # Implement this method in a subclass, have it return an ImageMagick Image.
    def paint_to(image, viewport)
      raise NotImplementedError
    end
  end
end
