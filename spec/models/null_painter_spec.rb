require 'spec_helper'

describe Mapstatic::Painter::NullPainter do
  it "should accept any geometry type, even garbage" do
    expect(Mapstatic::Painter::NullPainter.accept? "LineString").to be(true)
    expect(Mapstatic::Painter::NullPainter.accept? "foo").to be(true)
  end

  it "should draw without errors" do
    test_file = tempfile
    FileUtils.cp "spec/fixtures/maps/london.png", test_file
    image = MiniMagick::Image.new test_file
    image.resize "256x256"

    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 11,
      width: 256,
      height: 256,
    )
    feature = line_string
    map.geojson = feature
    map.fit_bounds

    painter = Mapstatic::Painter::NullPainter.new(map: map, feature: feature)
    painter.paint_to image, map.viewport

    expect(image.type).to eq("PNG")
  end

end
