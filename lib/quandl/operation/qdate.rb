module Quandl
module Operation

class QDate

  class << self
    def parse(value)
      date = Date.jd(value.to_i) if value.kind_of?(String) && value.numeric?
      date = Date.jd(value) if value.is_a?(Integer)
      date = Date.parse(value) if value.is_a?(String) && value =~ /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/
      date = value if value.is_a?(Date)
      date = value.to_date if value.respond_to?(:to_date)
      date
    rescue
      nil
    end
  end

end

end
end