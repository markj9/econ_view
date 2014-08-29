require 'spec_helper.rb'
require "savon/mock/spec_helper"
require "ostruct"

describe DatastreamClient do
  # include the helper module
  include Savon::SpecHelper

  # set Savon in and out of mock mode
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  describe "invalid status" do
    it "should raise a datastream error" do
      client = double('soap_client')
      error_message = "invalid request"
      username = 'test'
      password = 'test'
      allow(client).to receive(:call).with(any_args()).and_return(OpenStruct.new(:body => {:request_record_response => {
        :request_record_result => { :status_code => "4", :status_messgae => error_message } } }))
      @subject = DatastreamClient::DatastreamClient.new(username: username, password: password, client: client)
      expect{@subject.request_user_list("error")}.to raise_error(DatastreamClient::DatastreamError)
    end
  end

  describe "requesting a user list" do
    before(:each) do
      @soap_client = double("soap_client")
      username = 'test'
      password = 'test'
      source = 'datastream'
      @list_symbol = 'list_symbol'
      instrument = "#{@list_symbol}~LIST~#{username}"
      @econ_stat_symbol = "AFDCPI.."
      response = OpenStruct.new(:body => {:request_record_response => {
        :request_record_result => {:status_code => "0",
          :fields => {
            :field => [{:name=>"LINK_1", :value=> @econ_stat_symbol}, {:name=>"NAME_1", :value=>"AF CONSUMER PRICES (% CHANGE, AV) NADJ"},
                       {:name=>"LINK_2", :value=>"AADCPI.."}, {:name=>"NAME_2", :value=>"AA CONSUMER PRICES (% CHANGE, AV)"},
                       {:name=>"REF_COUNT", :value=>"120"}]
          }
        }
      }})
      allow(@soap_client).to receive(:call).with(:request_record,
                                                 message: { user: {username: "DS:" + username, password: password},
                                                            request: {source: source, instrument: instrument},
                                                            request_flags: 0}).and_return(response)
      @subject = DatastreamClient::DatastreamClient.new(username: username, password: password, client: @soap_client)
    end

    it "should request a user list" do
      expect(@soap_client).to receive(:call)
      @subject.request_user_list(@list_symbol)
    end

    it "should return an array of hashes containing econ statistics" do
      econ_stats = @subject.request_user_list(@list_symbol)
      expect(econ_stats[0][:symbol]).to eq(@econ_stat_symbol)
    end
  end
end

#res.body[:request_record_response][:request_record_result][:fields][:field]
