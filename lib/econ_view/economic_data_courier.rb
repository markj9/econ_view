require_relative 'datastream_client/datastream_client'
require 'ostruct'
module EconView
  class EconomicDataCourier
    attr_reader :datastream_client, :logger, :countries, :measurements

    def initialize(args = {} )
      @logger = Logger.new(STDOUT)
      @datastream_client = args[:client]
      @measurements = args.fetch(:measurements, {})
      @user_lists = args.fetch(:user_lists, [])
      @user_lists.each {|list| retrieve_datastream_user_list(list) }
    end

    def countries
      all_countries = []
      @measurements.each_value{|v| all_countries << v.keys}
      all_countries.flatten.uniq.sort
    end

    def measurement_for(code, country)
      if @measurements[code] && @measurements[code][country]
        return @measurements[code][country]
      end
      EconomicMeasurement.new(:most_recent_value => nil)
    end

    private

    def retrieve_datastream_user_list(list_symbol, years_back=3)
      econ_stats = @datastream_client.request_user_list(list_symbol)
      econ_stats.each do |econ_stat|
        begin
          symbol = econ_stat[:symbol]
          econ_stat_details = @datastream_client.request_symbol_details(symbol)
          econ_stat_measurements = @datastream_client.request_stat_measurements(symbol, years_back)
          econ_indicator_code = symbol[2..-1].downcase.to_sym
          country_sym = econ_stat_details[:country].downcase.to_sym
          @measurements[econ_indicator_code] = {} if @measurements[econ_indicator_code].nil?
          @measurements[econ_indicator_code][country_sym] = EconomicMeasurement.new(:most_recent_value =>
                                                                                    econ_stat_measurements.most_recent_value)
        rescue DatastreamClient::DatastreamError => e
          @logger.info("Failed to retrieve data for #{econ_stat[:symbol]} on user list #{list_symbol}")
          #raise DatastreamClient::DatastreamError.new, e.message + " for #{list_symbol}"
          next
        end
      end
    end
  end
end
