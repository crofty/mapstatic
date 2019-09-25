module Mapstatic
  class Painter::NullPainter < Painter
    def self.accept?(geometry_type)
      true
    end

    def paint_to(image, viewport)
      # Do nothing, just return the original image.
      image
    end
  end
end
