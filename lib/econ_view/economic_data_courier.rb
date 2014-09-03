require_relative 'datastream_client/datastream_client'
require 'ostruct'
module EconView
  class EconomicDataCourier
    attr_reader :datastream_client

    def initialize(args = {} )
      @datastream_client = args[:client]
    end

    def retrieve_datastream_user_list(list_symbol, years_back=3)
      list = Array.new
      econ_stats = @datastream_client.request_user_list(list_symbol)
      econ_stats.each do |econ_stat|
        econ_stat_details = @datastream_client.request_symbol_details(econ_stat[:symbol])
        econ_stat_measurements = @datastream_client.request_stat_measurements(econ_stat[:symbol], years_back)
        item = econ_stat.merge(econ_stat_details) unless econ_stat_details.nil?
        item = item.merge(econ_stat_measurements.to_h) unless econ_stat_measurements.nil?
        list << OpenStruct.new(item)
      end
      Hash[list.map {|item| [item.country.downcase.to_sym, item] }]
    end
  end
end
