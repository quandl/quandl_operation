class Time
  
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