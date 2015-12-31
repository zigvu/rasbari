# Class to enable memoization of client/servers
module Messaging
  module Connections
    class Cache

      # --------------------------------------------------------------------------
      # VideoCapture
      def video_capture
        @video_capture ||= Messaging::Connections::Cache::VCapture.new
      end
      class VCapture
        def rasbari
          @rasbari ||= Messaging::Connections::Cache::VCapture::Rasbari.new
        end
        class Rasbari
          def client(hostname)
            @client ||= {}
            @client[hostname] ||= Messaging::VideoCapture::RasbariClient.new(hostname)
          end
          def server(handler)
            @server ||= Messaging::VideoCapture::RasbariServer.new(handler)
          end
        end # END class Rasbari

        def nimki
          @nimki ||= Messaging::Connections::Cache::VCapture::Nimki.new
        end
        class Nimki
          def client
            @client ||= Messaging::VideoCapture::NimkiClient.new
          end
          def server(handler)
            @server ||= Messaging::VideoCapture::NimkiServer.new(handler)
          end
        end # END class Nimki
      end # END class VCapture
    end # END class Cache
    # --------------------------------------------------------------------------
  end
end
