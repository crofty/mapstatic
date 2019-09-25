require 'spec_helper'
describe Mapstatic::Map do
  it "returns correct width and height" do
    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 12,
      width: 256,
      height: 256,
    )

    expect(map.width).to eql(256)
    expect(map.height).to eql(256)
  end

  it "doesn't crash when trying to fit bounds with no geojson data provided" do
    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 12,
      width: 256,
      height: 256,
    )

    expect do
      map.fit_bounds
    end.not_to raise_error
  end

  it "should store width and height as integers" do
    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 12,
      width: "256", # Notice that width and height are given as strings
      height: "256",
    )

    expect(map.width.is_a? Integer).to be true
    expect(map.height.is_a? Integer).to be true
  end

  it "should be able to take geojson data as a Hash" do
    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 12,
      width: 256,
      height: 256,
    )

    expect do
      map.geojson = line_string
      map.fit_bounds
    end.not_to raise_error
  end

  it "should be able to take geojson data as a GeoJSON string" do
    map = Mapstatic::Map.new(
      lat: 51.515579783755925,
      lng: -0.1373291015625,
      zoom: 12,
      width: 256,
      height: 256,
    )

    expect do
      map.geojson = line_string.to_json
      map.fit_bounds
    end.not_to raise_error
  end

  describe "the resulting image" do

    it "is the correct image when got via lat lng" do
      output_path = 'london.png'
      map = Mapstatic::Map.new(
        lat: 51.515579783755925,
        lng: -0.1373291015625,
        zoom: 11,
        width: 256,
        height: 256,
      )
      VCR.use_cassette('osm-london') do
        map.render_map output_path
      end
      images_are_identical(output_path, 'spec/fixtures/maps/london.png')
      File.delete output_path
    end

    it "is the correct image when got via bounding box" do
      output_path = 'london.png'
      map = Mapstatic::Map.new(
        bbox: [-0.2252197265625,51.4608524464555,-0.0494384765625,51.570241445811234],
        zoom: 11,
      )
      VCR.use_cassette('osm-london') do
        map.render_map output_path
      end
      images_are_identical(output_path, 'spec/fixtures/maps/london.png')
      File.delete output_path
    end

    it "renders the correct image" do
      output_path = 'thames.png'
      map = Mapstatic::Map.new(
        bbox: [-0.169851,51.480829,0.027421,51.513658],
        zoom: 12,
      )
      VCR.use_cassette('osm-thames') do
        map.render_map output_path
      end
      images_are_identical(output_path, 'spec/fixtures/maps/thames.png')
      File.delete output_path
    end
  end

  describe '#render_map' do
    context 'when retrieving tile image fails' do
      it 'raises TileRequestError' do
        output_path = 'london.png'
        map = Mapstatic::Map.new(
          bbox: [-0.2252197265625,51.4608524464555,-0.0494384765625,51.570241445811234],
          zoom: 11,
        )

        expect do
          VCR.use_cassette('osm-london-fail') do
            map.render_map output_path
          end
        end.to raise_error('Retrieving tile from http://b.tile.openstreetmap.org/11/1022/680.png '\
                           'failed with status code 500.')
      end
    end
  end

  describe "image width" do

    context "when calculated from the bounding box" do

      it "doubles with each zoom level" do
        bbox = [-11.29,49.78,2.45,59.71]

        map1 = Mapstatic::Map.new(
          bbox: bbox,
          zoom: 6,
        )
        expect( map1.width.to_i ).to eql( 625 )

        map2 =  Mapstatic::Map.new(
          bbox: bbox,
          zoom: map1.zoom + 1,
        )
        expect( map2.width.to_i ).to eql( map1.width.to_i * 2 )
      end
    end

  end

  describe "image height" do

    context "when calculated from the bounding box" do

      it "doubles with each zoom level" do
        bbox = [-11.29, 49.78, 2.45, 59.71]
        map1 = Mapstatic::Map.new(
          bbox: bbox,
          zoom: 2,
        )
        expect( map1.height.to_i ).to eql( 49 )

        map2 = Mapstatic::Map.new(
          bbox: bbox,
          zoom: 3,
        )
        expect( map2.height.to_i ).to eql( map1.height.to_i * 2 )
      end
    end

  end

end
