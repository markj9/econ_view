require "econ_view/economic_data_courier"
require "econ_view/configuration"
module EconView
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
