module Quandl
module Operation
  
class CommonLogger
  
  class << self
  
    delegate :info, :debug, :with_time_elapsed, to: :logger, allow_nil: true
  
    def logger
      @@logger if defined?(@@logger)
    end
    def use(value)
      @@logger = value
    end
  
  end
  
end
end
end