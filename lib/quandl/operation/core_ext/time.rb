class Time
  
  class << self
    
    def log_elapsed(message=nil, &block)
      timer = Time.now
      result = block.call
      message = "#{message} (#{timer.elapsed.microseconds}ms)"
      puts message
      Rails.logger.debug message
      result
    end
  
    def elapsed(message=nil, &block)
      log_elapsed(message, &block)
    end
  
  end
  
  def microseconds
    (self.to_f * 1000.0).to_i
  end
  
  def elapsed
    elapsed_since(Time.now)
  end
  
  def elapsed_since(time)
    time - self
  end
  
  def elapsed_ms
    "#{elapsed.microseconds}ms"
  end
  
end