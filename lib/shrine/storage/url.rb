require "shrine"
require "down"
require "net/http"

class Shrine
  module Storage
    class Url
      def upload(io, id, **)
        id.replace(io.url)
      end

      def download(id)
        Down.download(id)
      end

      def open(id)
        Down.open(id)
      end

      def exists?(id)
        response = request(:head, id)
        (200..299).cover?(response.code.to_i)
      end

      def url(id, **options)
        id
      end

      def delete(id)
        request(:delete, id)
      end

      private

      def request(method, url)
        response = nil
        uri = URI(url)
        Net::HTTP.start(uri.host, uri.port) do |http|
          response = http.send(method, uri.request_uri)
        end
        response
      end
    end
  end
end
