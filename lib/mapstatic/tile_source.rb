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
      requests = tiles.map{|tile| request = Typhoeus::Request.new(tile_url(tile), followlocation: true); hydra.queue(request); request }
      hydra.run

      # responses = []
      # connection.in_parallel do
      #   tiles.each do |tile|
      #     responses << connection.get(tile_url(tile))
      #   end
      # end

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

    # def connection
    #   @connection ||= Faraday.new do |builder|
    #     builder.use FaradayMiddleware::FollowRedirects, limit: 3
    #     builder.adapter :typhoeus
    #   end
    # end

  end

end
