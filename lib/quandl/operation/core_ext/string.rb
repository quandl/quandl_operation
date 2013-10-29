class String
  
  def numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end
  
end