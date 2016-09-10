require 'typhoeus'

module Mapstatic

  class TileSource

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def get_tiles(tiles)
      # custom user agent here
      hydra = Typhoeus::Hydra.new
      requests = tiles.map do |tile|
        request = Typhoeus::Request.new(tile_url(tile), Mapstatic.options[:typhoeus_options])
        hydra.queue(request)
        request
      end
      hydra.run

      responses = requests.map{|r| r.response}
      responses.map do |res|
        fail Mapstatic::Errors::TileRequestError, res unless res.success?
        res.body
      end
    end

    private

    attr_reader :connection

    def tile_url(tile)
      url.
        gsub(/\{x\}/,tile.x.to_s).
        gsub(/\{y\}/,tile.y.to_s).
        gsub(/\{z\}/,tile.zoom.to_s).
        gsub(/\{s\}/,subdomain_for_tile(tile))
    end

    def subdomain_for_tile(tile)
      i = (tile.x + tile.y) % subdomains.length
      subdomains[i]
    end

    def subdomains
      ['a','b','c']
    end

  end

end
