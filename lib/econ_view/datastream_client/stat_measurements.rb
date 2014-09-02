module DatastreamClient
  class StatMeasurements
    attr_reader :dates, :values, :most_recent_value

    def initialize(args)
      if args[:dates].size != args[:values].size
        raise DatastreamError.new, "Invalid dates or values with dates = #{dates} and values = #{values}"
      end
      @dates = args[:dates]
      @values = args[:values]
      @most_recent_value = @values.last
    end

    def most_recent_value
      @values.last
    end

    def to_h
      hash = {}
      self.instance_variables.each {|var| hash[var.to_s.delete("@").to_sym] = self.instance_variable_get(var) }
      hash
    end
  end
end
