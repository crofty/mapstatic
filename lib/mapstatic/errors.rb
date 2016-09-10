module Mapstatic
  module Errors
    # Default Mapstatic error class for all custom errors.
    class MapstaticError < StandardError
    end

    # Raised when a request for a tile fails.
    class TileRequestError < MapstaticError
      def initialize(response)
        url = response.request.base_url
        status = response.code
        super("Retrieving tile from #{url} failed with status code #{status}.")
      end
    end
  end
end
