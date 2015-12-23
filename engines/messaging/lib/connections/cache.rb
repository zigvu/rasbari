module Connections
  class Cache

    # VideoVideoCapture
    def video_capture
      @video_capture ||= Connections::Cache::VCapture.new
    end
    class VCapture
      def rasbari
        @rasbari ||= Connections::Cache::VCapture::Rasbari.new
      end
      class Rasbari
        def client(hostname)
          @client ||= {}
          @client[hostname] ||= VideoCapture::RasbariClient.new(hostname)
        end
        def server
          @server ||= false # TODO: fill
        end
      end

      def nimki
        @nimki ||= Connections::Cache::VCapture::Nimki.new
      end
      class Nimki
        def client
          @client ||= false # TODO: fill
        end
        def server(handler)
          @server ||= VideoCapture::NimkiServer.new(handler)
        end
      end
    end
  end
end
