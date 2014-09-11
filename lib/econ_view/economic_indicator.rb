module EconView
class EconomicIndicator

  attr_accessor :name, :high, :low, :code, :json_name, :courier
  OUTSIDE_THRESHOLD = 1.0
  INSIDE_THRESHOLD = 0.0
  CPI = :"dcpi.."

  def self.create(args)
    indicators = []
    args[:config].each do |key, value|
      class_name = value.delete(:class_name)
      if class_name.nil?
        i = EconomicIndicator.new(name: key, attrs: value)
      else
        i = Object.const_get(class_name).new(name: key, attrs: value)
      end
      i.courier = args[:courier]
      indicators << i
    end
    indicators
  end

  def initialize(args)
    @name = args[:name]
    args[:attrs].each {|k,v| send("#{k}=",v)}
  end

  def code=(code)
    if code.is_a?String
      @code= code.downcase.to_sym
    else
      @code = code
    end
  end

  def within_threshold?(value)
    if (!high.nil? && !high.is_a?(String) && value > high) ||
      (!low.nil? && !low.is_a?(String)  && value < low)
      return false
    end
    true
  end

  def threshold_value_for(country)
    value = compute_value(country)
    return {} unless !value.nil?
    name_string = name.to_s.upcase
    if within_threshold?(value)
      result = {"SumOf#{json_name}" => INSIDE_THRESHOLD}
    else
      result = {"SumOf#{json_name}" => OUTSIDE_THRESHOLD}
    end
    {json_name => value}.merge(result)
  end

  def compute_value(country)
    measurement = courier.measurement_for(code,country)
    return nil if !valid_measurement?(measurement)
    measurement.most_recent_value.to_f
  end

  private

  def valid_measurement?(measurement)
    if measurement.nil? || measurement.most_recent_value.nil? ||
      measurement.most_recent_value == "NaN"
      return false
    end
    true
  end
end
end
