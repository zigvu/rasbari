module Messaging
  module BaseLibs
    class Mlogger < Logger

      class Mformatter < Logger::Formatter
        def call(severity, time, progname, msg)
          Format % [severity[0..0], format_datetime(time), $$, colorizeSev(severity), progname, msgWithFilename(msg)]
        end

        def msgWithFilename(msg)
          "#{File.basename(caller[4].split(":")[0])}: #{msg2str(msg)}"
        end

        def colorizeSev(severity)
          case severity
          when 'DEBUG'
            colorize(severity, "gray")
          when 'INFO'
            colorize(severity, "yellow")
          when 'WARN'
            colorize(severity, "magenta")
          when 'ERROR'
            colorize(severity, "red")
          when 'UNKNOWN'
            colorize(severity, "red", {style: "bold"})
          end
        end

        def colorize(text, color, options = {})
          background = options[:background] || options[:bg] || false
          style = options[:style]
          offsets = ["gray","red", "green", "yellow", "blue", "magenta", "cyan","white"]
          styles = ["normal","bold","dark","italic","underline","xx","xx","underline","xx","strikethrough"]
          start = background ? 40 : 30
          color_code = start + (offsets.index(color) || 8)
          style_code = styles.index(style) || 0
          "\e[#{style_code};#{color_code}m#{text}\e[0m"
        end

        def format_datetime(time)
          "#{time.strftime('%Y-%m-%d %H:%M:%S')}"
        end
      end

      def initialize
        super(STDOUT)
        self.formatter = Messaging::BaseLibs::Mlogger::Mformatter.new
        self.level = Logger::DEBUG
      end

    end
  end
end
