require_relative 'datastream_client/datastream_client'
require 'ostruct'
module EconView
  class EconomicDataCourier
    attr_reader :datastream_client, :datastream_user_lists

    def initialize(args)
      config = {username: EconView.configuration.datastream_username }
      #@datastream_client = DatastreamClient::DatastreamClient.new config
      @datastream_client = args[:client]
    end

    def retrieve_datastream_user_list(list_symbol)
      list = Array.new
      symbols = @datastream_client.request_user_list(list_symbol)
      symbols.each do |symbol|
        symbol_details = @datastream_client.request_symbol_details(symbol[:symbol])
        item = OpenStruct.new(symbol.merge(symbol_details))
        list << item
      end
      list
    end
  end
end
