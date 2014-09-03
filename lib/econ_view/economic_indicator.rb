class EconomicIndicator

  attr_accessor :name, :high, :low, :code, :json_name, :courier

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
end
