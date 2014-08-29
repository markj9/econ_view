require 'savon'
require_relative 'datastream_error'
module DatastreamClient
  class DatastreamClient
    GOOD_STATUS = "0"
    attr_reader :username, :password
    WSDL_URL = 'http://dataworks.thomson.com/Dataworks/Enterprise/1.0/webserviceclient.asmx?WSDL'

    def initialize(config)
      @username = config[:username]
      @password = config[:password]
      @client = config[:client] || Savon.client(wsdl: WSDL_URL, convert_request_keys_to: :camelcase, log: false)
    end

    def request_user_list(symbol)
      Array stats = Array.new
      response = request_record(build_list_instrument(symbol))
      funky_array = field_from(response)
      funky_array.each_slice(2) do |slice|
        if slice.size == 2
          stat = Hash.new
          stat[:symbol] = slice[0][:value]
          stat[:description] = slice[1][:value]
          stats << stat
        end
      end
      stats
    end

    def request_symbol_details(symbol)
      response = request_record(build_stat_detail_instrument(symbol))
      details = field_from(response)
      country = ''
      details.each do |detail|
        if detail[:name] == "GEOGN"
          country = detail[:value]
        end
      end
      {country: country}
    end

    private

    def field_from(response)
      response.body[:request_record_response][:request_record_result][:fields][:field]
    end

    def request_record(instrument)
      response = @client.call(:request_record, build_message(instrument))
      status_code = response.body[:request_record_response][:request_record_result][:status_code]
      if status_code != "0"
       status_message = response.body[:request_record_response][:request_record_result][:status_message]
       raise DatastreamError.new, status_message
      end
      response
    end

    def build_message(instrument)
      {message: {user: {username: "DS:" + @username,
                         password: @password},
               request: {source: "Datastream",
                         instrument: instrument},
        request_flags: 0} }
    end

    def build_list_instrument(symbol)
      "#{symbol}~LIST~##{@username}"
    end

    def build_stat_detail_instrument(symbol)
      "#{symbol}~REP~=GEOGN"
    end
  end
end
