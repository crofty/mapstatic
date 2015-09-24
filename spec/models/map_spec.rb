require 'spec_helper'
describe Mapstatic::Map do

  describe "the resulting image" do

    it "is the correct image when got via lat lng" do
      output_path = 'london.png'
      map = Mapstatic::Map.new(
        :lat => 51.515579783755925,
        :lng => -0.1373291015625,
        :zoom => 11,
        :width => 256,
        :height => 256,
        :provider => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
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
        :bbox => "-0.2252197265625,51.4608524464555,-0.0494384765625,51.570241445811234",
        :zoom => 11,
        :provider => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
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
        :provider => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        :zoom => 12,
        :bbox => '-0.169851,51.480829,0.027421,51.513658'
      )
      VCR.use_cassette('osm-thames') do
        map.render_map output_path
      end
      images_are_identical(output_path, 'spec/fixtures/maps/thames.png')
      File.delete output_path
    end

    def images_are_identical(image1, image2)
      `compare -metric MAE #{image1} #{image2} null: 2>&1`.chomp.should == "0 (0)"
    end
  end

  describe '#render_map' do
    context 'when retrieving tile image fails' do
      it 'raises TileRequestError' do
        output_path = 'london.png'
        map = Mapstatic::Map.new(
          :bbox => '-0.2252197265625,51.4608524464555,-0.0494384765625,51.570241445811234',
          :zoom => 11,
          :provider => 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
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
        bbox = '-11.29,49.78,2.45,59.71'

        image = Mapstatic::Map.new( :zoom => 6, :bbox => bbox)
        expect( image.width.to_i ).to eql( 625 )

        image = Mapstatic::Map.new( :zoom => 7, :bbox => bbox)
        expect( image.width.to_i ).to eql( 1250 )
      end
    end

  end

  describe "image height" do

    context "when calculated from the bounding box" do

      it "doubles with each zoom level" do
        bbox = '-11.29,49.78,2.45,59.71'

        image = Mapstatic::Map.new( :zoom => 2, :bbox => bbox)
        expect( image.height.to_i ).to eql( 49 )

        image = Mapstatic::Map.new( :zoom => 3, :bbox => bbox)
        expect( image.height.to_i ).to eql( 98 )
      end
    end

  end

end
