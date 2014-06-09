module Loggly
  class LogglyException < StandardError; end
  class UnexpectedHTTPException < LogglyException; end
  class PermissionDeniedException < LogglyException; end
  class NonExistentRecord < LogglyException; end
  class LogglyConnectionException < LogglyException; end
  class LogglyResponseException < LogglyException; end
end
