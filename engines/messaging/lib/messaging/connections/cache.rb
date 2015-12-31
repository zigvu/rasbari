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

    end # END class RasbariCache
  end
end
