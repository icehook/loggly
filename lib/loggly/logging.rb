module Loggly
  module Logging
    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger ||= init_logger(STDOUT, :debug)
    end

    def init_logger(io, level)
      logger = unless io
        Logger.new(STDOUT)
      else
        Logger.new(io)
      end

      if level == :debug
        logger.level = Logger::DEBUG
      else
        logger.level = Logger::INFO
      end

      logger
    end
  end
end
