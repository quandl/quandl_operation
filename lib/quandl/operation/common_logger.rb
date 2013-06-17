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
  
  module PerformanceLog
    
    extend ActiveSupport::Concern

    module ClassMethods
    
      def perform(*args)
        t1 = Time.now
        r = super
        CommonLogger.debug "#{self.class.name}.perform (#{( (t1 - Time.now).to_f * 1000).to_i }ms)"
        r
      end
    end
  
  end
  
end
end
end