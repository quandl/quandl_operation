class Date
  def start_of_frequency(freq)
    case freq.to_sym
    when :daily     then self
    when :weekly    then beginning_of_week
    when :monthly   then beginning_of_month
    when :quarterly then beginning_of_quarter
    when :annual    then beginning_of_year
    when :annually  then beginning_of_year
    else
      self
    end
  end

  def end_of_frequency(freq)
    case freq.to_sym
    when :daily     then self
    when :weekly    then end_of_week
    when :monthly   then end_of_month
    when :quarterly then end_of_quarter
    when :annual    then end_of_year
    when :annually  then end_of_year
    else
      self
    end
  end

  def ranging_until(date)
    self..date
  end

  def occurrences_of_frequency_ahead(occurrences, freq)
    occurrences_of_frequency_ago(occurrences.to_i * -1, freq)
  end

  def occurrences_of_frequency_ago(occurrences, freq)
    occurrences_of_frequency(occurrences, freq)
  end

  def occurrences_of_frequency(occurrences, freq)
    # ensure occurrences is an integer
    occurrences = occurrences.to_i
    case freq.try(:to_sym)
    when :weekly    then self - occurrences.weeks
    when :monthly   then self - occurrences.months
    when :quarterly then self - (occurrences * 3).months
    when :annual    then self - occurrences.years
    when :annually  then self - occurrences.years
    else
      self - occurrences
    end
  end
end
