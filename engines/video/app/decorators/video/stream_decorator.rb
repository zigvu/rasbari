module Video
  class StreamDecorator < Draper::Decorator
    delegate_all

    def machine
      # object.published_at.strftime("%A, %B %e")
      'Video Capture 1 [vm5]'
    end
  end
end
