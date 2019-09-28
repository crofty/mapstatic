require 'spec_helper'

describe Mapstatic::BoundingBox do
  it "should require initial values" do
    expect do
      Mapstatic::BoundingBox.new
    end.to raise_error KeyError
  end

  it "should return its data as arrays" do
    left   = -0.169851
    bottom = 51.480829
    right  = 0.027421
    top    = 51.513658

    bbox = Mapstatic::BoundingBox.new left: left, bottom: bottom, right: right, top: top

    expect(bbox.to_latlng_coordinates.is_a?(Array)).to be(true)

    zoom = 12
    expect(bbox.to_xy_coordinates(zoom).is_a?(Array)).to be(true)
  end

  it "should calculate centerpoint correctly" do
    left   = -100.0
    bottom = -50.0
    right  = 100.0
    top    = 50.0

    bbox = Mapstatic::BoundingBox.new left: left, bottom: bottom, right: right, top: top
    center = bbox.center

    expect(center[:lat]).to eq(0)
    expect(center[:lng]).to eq(0)
  end

  it "should detect nested boxes correctly" do
    outer =  {left: -100.0, bottom: -50.0, right: 100.0, top: 50.0}
    inner =  {left: -90.0, bottom: -40.0, right: 90.0, top: 40.0}
    intersecting = {left: -90.0, bottom: -60.0, right: 110.0, top: 50.0}

    outer_box = Mapstatic::BoundingBox.new outer
    inner_box = Mapstatic::BoundingBox.new inner
    intersecting_box = Mapstatic::BoundingBox.new intersecting

    expect(inner_box.fits_in? outer_box).to be(true)
    expect(outer_box.contains? inner_box).to be(true)
    expect(inner_box.contains? outer_box).to be(false)
    expect(outer_box.fits_in? inner_box).to be(false)
    expect(intersecting_box.fits_in? outer_box).to be(false)
  end

  it "should build a box around given coordinates" do
    coordinates = [[0.0, 0.0], [10.0, 10.0]]
    bbox = Mapstatic::BoundingBox.for coordinates

    expect(bbox.left).to be <= 0
    expect(bbox.bottom).to be <= 0
    expect(bbox.right).to be >= 10
    expect(bbox.top).to be >= 10
  end

  it "should construct a box based on center coordinates and dimensions" do
    outer_box = Mapstatic::BoundingBox.from(
      center_lat: 0,
      center_lng: 0,
      width: 200,
      height: 200,
      zoom: 12
    )

    inner_box = Mapstatic::BoundingBox.from(
      center_lat: 0,
      center_lng: 0,
      width: 150,
      height: 150,
      zoom: 12
    )

    expect(inner_box.fits_in? outer_box).to be(true)
  end
end
