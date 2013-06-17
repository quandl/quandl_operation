class Date
  
  def start_of_frequency(freq)
    case freq.to_sym
    when :daily     then self
    when :weekly    then self.beginning_of_week
    when :monthly   then self.beginning_of_month
    when :quarterly then self.beginning_of_quarter
    when :annual    then self.beginning_of_year
    when :annually  then self.beginning_of_year
    end
  end
  
  def end_of_frequency(freq)
    case freq.to_sym
    when :daily     then self
    when :weekly    then self.end_of_week
    when :monthly   then self.end_of_month
    when :quarterly then self.end_of_quarter
    when :annual    then self.end_of_year
    when :annually  then self.end_of_year
    end
  end
  
end