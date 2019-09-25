require 'nokogiri'

module Mapstatic
  class GpxFile
    attr_reader :tracks, :routes

    def initialize(filename)
      @filename = filename
      @tracks = []
      @routes = []
      parse
    end

    def geojson_data
      features = features_from(@tracks) + features_from(@routes)

      {
        type: "FeatureCollection",
        features: features
      }
    end

    def to_geojson
      geojson_data.to_json
    end

    def self.to_geojson(filename)
      GpxFile.new(filename).to_geojson
    end

    private

    def parse
      xml = Nokogiri::XML File.open(@filename)

      xml.css("trk").each do |trk|
        @tracks << trk.css("trkpt").map do |pt|
          [pt.attributes["lon"].value.to_f, pt.attributes["lat"].value.to_f]
        end
      end

      xml.css("rte").each do |rte|
        @routes << rte.css("rtept").map do |pt|
          [pt.attributes["lon"].value.to_f, pt.attributes["lat"].value.to_f]
        end
      end
    end

    def features_from(tracks)
      tracks.map do |track|
        {
          type: "Feature",
          geometry: {
            type: "LineString",
            coordinates: track
          }
        }
      end
    end
  end
end
