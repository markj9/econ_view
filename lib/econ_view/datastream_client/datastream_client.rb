module DatastreamClient
  class DatastreamClient
    attr_reader :username
    WSDL_URL = 'http://dataworks.thomson.com/Dataworks/Enterprise/1.0/webserviceclient.asmx?WSDL'

    def initialize(config)
      @username = config[:username]
      @client = Savon.client(wsdl: WSDL_URL)
    end

    def request_record(symbol)
    end
  end
end
