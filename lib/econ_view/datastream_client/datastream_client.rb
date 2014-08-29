require 'savon'
require_relative 'datastream_error'
module DatastreamClient
  class DatastreamClient
    attr_reader :username, :password
    WSDL_URL = 'http://dataworks.thomson.com/Dataworks/Enterprise/1.0/webserviceclient.asmx?WSDL'

    def initialize(config)
      @username = config[:username]
      @password = config[:password]
      @client = config[:client] || Savon.client(wsdl: WSDL_URL, convert_request_keys_to: :camelcase)
    end

    def request_user_list(symbol)
      Array stats = Array.new
      response = request_record(symbol)
      funky_array = response.body[:request_record_response][:request_record_result][:fields][:field]
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


    private

    def request_record(symbol)
      response = @client.call(:request_record, build_message(symbol))
      status_code = response.body[:request_record_response][:request_record_result][:status_code]
      if status_code != "0"
       status_message = response.body[:request_record_response][:request_record_result][:status_message]
       raise DatastreamError.new, status_message
      end
      response
    end

    def build_message(symbol)
      {message: {user: {username: "DS:" + @username,
                         password: @password},
               request: {source: "datastream",
                         instrument: "#{symbol}~LIST~#{@username}"},
        request_flags: 0} }
    end
  end
end
