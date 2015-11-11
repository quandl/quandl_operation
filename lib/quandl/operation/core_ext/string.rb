class String
  def numeric?
    return true if self =~ /^\d+$/
    begin
      true if Float(self)
    rescue
      false
    end
  end
end
