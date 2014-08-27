require_relative 'datastream_client/datastream_client'
module EconView
  class EconomicDataCourier
    attr_reader :datastream_client, :datastream_user_lists

    def initialize(config = Configuration.new)
      config = {username: config.datastream_username }
      @datastream_client = DatastreamClient::DatastreamClient.new config
    end

    def retrieve_datastream_user_list(list_symbol)
      @datastream_client.request_record(list_symbol)
    end
  end
end
