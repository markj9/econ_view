require_relative 'datastream_client/datastream_client'
require 'ostruct'
module EconView
  class EconomicDataCourier
    attr_reader :datastream_client, :datastream_user_lists

    def initialize(args = {} )
      config = {username: EconView.configuration.datastream_username }
      #@datastream_client = DatastreamClient::DatastreamClient.new config
      @datastream_client = args[:client] || DatastreamClient::DatastreamClient.new(config)
    end

    def retrieve_datastream_user_list(list_symbol)
      list = Array.new
      econ_stats = @datastream_client.request_user_list(list_symbol)
      econ_stats.each do |econ_stat|
        econ_stat_details = @datastream_client.request_symbol_details(econ_stat[:symbol])
        item = OpenStruct.new(econ_stat.merge(econ_stat_details))
        list << item
      end
      list
    end
  end
end
