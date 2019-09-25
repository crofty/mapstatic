require 'spec_helper'

describe Mapstatic::Painter::LineStringPainter do
  it "should only accept LineString geometry type" do
    expect(Mapstatic::Painter::LineStringPainter.accept? "LineString").to be(true)
    expect(Mapstatic::Painter::LineStringPainter.accept? "Point").to be(false)
    expect(Mapstatic::Painter::LineStringPainter.accept? "Polygon").to be(false)
    expect(Mapstatic::Painter::LineStringPainter.accept? "MultiPoint").to be(false)
    expect(Mapstatic::Painter::LineStringPainter.accept? "MultiLineString").to be(false)
    expect(Mapstatic::Painter::LineStringPainter.accept? "MultiPolygon").to be(false)
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
    feature = line_string.to_json
    map.geojson = feature
    map.fit_bounds

    painter = Mapstatic::Painter::LineStringPainter.new(map: map, feature: JSON.parse(feature))
    painter.paint_to image, map.viewport

    expect(image.type).to eq("PNG")

    File.delete test_file
  end

end
