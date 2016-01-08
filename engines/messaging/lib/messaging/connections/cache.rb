# Class to enable memoization of client/servers
module Messaging
  module Connections
    class RasbariCache

      # --------------------------------------------------------------------------
      # VideoCapture
      def video_capture
        @video_capture ||= Messaging::Connections::RasbariCache::VideoCapture.new
      end
      class VideoCapture
        def client(hostname)
          @clients ||= {}
          @clients[hostname] ||= Video::RasbariClient.new(hostname)
        end
        def server(handler)
          @server ||= Video::RasbariServer.new(handler)
        end
      end # END class VideoCapture
      # --------------------------------------------------------------------------

      # --------------------------------------------------------------------------
      # Storage
      def storage
        @storage ||= Messaging::Connections::RasbariCache::Storage.new
      end
      class Storage
        def client(hostname)
          @clients ||= {}
          @clients[hostname] ||= Messaging::Connections::Clients::StorageClient.new(hostname)
        end
      end # END class Storage
      # --------------------------------------------------------------------------

    end # END class RasbariCache
  end
end
