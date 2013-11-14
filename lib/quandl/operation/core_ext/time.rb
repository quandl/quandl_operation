class Time
  
  class << self
    
    def log_elapsed(message=nil, &block)
      timer = Time.now
      result = block.call
      message = "#{message} (#{timer.elapsed.microseconds}ms)"
      puts message
      Quandl::Logger.info(message)
      result
    end
  
    def elapsed(message=nil, &block)
      log_elapsed(message, &block)
    end
  
  end
  
  def week_from_beginning_to_end
    (self.beginning_of_week .. self.end_of_week)
  end
  def this_week?
    self.week_from_beginning_to_end.cover?(Time.now)
  end

  def month_from_beginning_to_end
    (self.beginning_of_month .. self.end_of_month)
  end
  def this_month?
    self.month_from_beginning_to_end.cover?(Time.now)
  end

  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
  
  def microseconds
    (self.to_f * 1000.0).to_i
  end
  
  def self.elapsed(message=nil, &block)
    timer = Time.now
    result = block.call
    puts "#{message} (#{timer.elapsed.microseconds}ms)"
    result
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