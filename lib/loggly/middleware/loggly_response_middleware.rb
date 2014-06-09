module Loggly
  class LogglyResponseMiddleware < Faraday::Response::Middleware
    include Loggly::Logging

    ERROR_STATUSES = (400...600)

    def on_complete(env)
      case env[:status]
      when 401
        raise PermissionDeniedException
      when 404
        raise NonExistentRecord
      when 0
        raise UnexpectedHTTPException, "recieved an unexpected HTTP response code #{env[:status]}"
      when ERROR_STATUSES
        raise UnexpectedHTTPException, "recieved an unexpected HTTP response code #{env[:status]}"
      end

      env
    end

  end
end
