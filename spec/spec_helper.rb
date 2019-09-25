require 'mapstatic'
require 'mapstatic/gpx_file'
require 'vcr'
require 'json'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

def images_are_identical(image1, image2)
  expect(`compare -metric MAE #{image1} #{image2} null: 2>&1`.chomp).to eq("0 (0)")
end

def line_string
  {
    "type": "Feature",
    "geometry": {
      "type": "LineString",
      "coordinates": [[-0.3481, 51.5283], [0,2208, 51,4462]]
    }
  }
end

def geojson_data
  {
    type: "FeatureCollection",
    features: [line_string]
  }
end

def tempfile
  file = Tempfile.new ["mapstatic", ".png"]
  filename = file.path
  file.close
  file.unlink
  filename
end
