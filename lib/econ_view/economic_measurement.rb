module EconView
  class EconomicMeasurement
    attr_accessor :most_recent_value
    def initialize(args={})
      @most_recent_value = args.fetch(:most_recent_value)
    end
  end
end
