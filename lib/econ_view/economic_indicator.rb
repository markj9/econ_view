class EconomicIndicator

  attr_accessor :name, :high, :low, :code, :json_name, :courier, :countries, :measurements
  OUTSIDE_THRESHOLD = 1.0
  INSIDE_THRESHOLD = 0.0

  def self.create(args)
    indicators = []
    args[:config].each do |key, value|
      i = EconomicIndicator.new(name: key, attrs: value)
      i.courier = args[:courier]
      indicators << i
    end
    indicators
  end

  def initialize(args)
    @name = args[:name]
    args[:attrs].each {|k,v| send("#{k}=",v)}
  end

  def measurements
    if @measurements.nil? && (!@code.nil? || !@courier.nil?)
      @measurements = @courier.retrieve_datastream_user_list(@code)
    end
    @measurements
  end

  def countries
    measurements.keys
  end

  def within_threshold?(country)
    if (!high.nil? && !high.is_a?(String) && measurements[country].most_recent_value.to_f > high) ||
      (!low.nil? && !low.is_a?(String)  && measurements[country].most_recent_value.to_f < low)
      return false
    end
    true
  rescue ArgumentError
    binding.pry
  end

  def measurements_for(country)
    if measurements[country].nil? || measurements[country].most_recent_value.nil? ||
      measurements[country].most_recent_value == "NaN"
      return {}
    end
    name_string = name.to_s.upcase
    if within_threshold?(country)
      result = {"SumOf#{json_name}" => INSIDE_THRESHOLD}
    else
      result = {"SumOf#{json_name}" => OUTSIDE_THRESHOLD}
    end
    {json_name => measurements[country].most_recent_value.to_f}.merge(result)
  end
end
