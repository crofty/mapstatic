require 'spec_helper'

describe Mapstatic::GpxFile do
  it "should require filename" do
    expect do
      Mapstatic::GpxFile.new
    end.to raise_error ArgumentError
  end

  it "should parse gpx file correctly" do
    gpx = Mapstatic::GpxFile.new "spec/fixtures/gpx/joensuu.gpx"
    expect(gpx.tracks.length).to eq 1
    expect(gpx.routes.length).to eq 0
    expect(gpx.tracks.first.length).to eq 288
  end

  it "should output proper geojson data" do
    gpx = Mapstatic::GpxFile.new "spec/fixtures/gpx/joensuu.gpx"
    output = gpx.geojson_data

    expect(output.is_a? Hash).to be true
    expect(output[:type]).to eq "FeatureCollection"
    expect(output[:features].is_a? Array).to be true
    expect(output[:features].count).to eq 1

    feature = output[:features].first

    expect(feature[:type]).to eq "Feature"
    expect(feature[:geometry][:type]).to eq "LineString"
    expect(feature[:geometry][:coordinates].is_a? Array).to be true

    expect do
      JSON.parse gpx.to_geojson
    end.not_to raise_error
  end
end
