require 'spec_helper.rb'
require "savon/mock/spec_helper"

describe DatastreamClient do
  # include the helper module
  include Savon::SpecHelper

  # set Savon in and out of mock mode
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  it "should request a user list" do
    soap_client = double("soap_client")
    username = 'test'
    password = 'test'
    source = 'datastream'
    list_symbol = 'list_symbol'
    instrument = "#{list_symbol}~LIST~#xcen905"
    expect(soap_client).to receive(:call).with(:request_record,
                                               message: { user: {username: username, password: password},
                                                          request: {source: source, instrument: instrument},
                                                          request_flags: 0})
    subject = DatastreamClient::DatastreamClient.new(username: 'test', password: 'test', client: soap_client)
    subject.request_user_list(list_symbol)
  end
end

#res.body[:request_record_response][:request_record_result][:fields][:field]
