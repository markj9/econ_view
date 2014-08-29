require 'spec_helper.rb'
require "savon/mock/spec_helper"
require "ostruct"

describe DatastreamClient do
  # include the helper module
  include Savon::SpecHelper

  # set Savon in and out of mock mode
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  before(:each) do
    @username = 'test'
    @password = 'test'
    @soap_client = double("soap_client")
    @source = 'Datastream'
    @subject = DatastreamClient::DatastreamClient.new(username: @username, password: @password, client: @soap_client)
    @econ_stat_symbol = "AFDCPI.."
  end

  describe "invalid status" do
    it "should raise a datastream error" do
      error_message = "invalid request"
      allow(@soap_client).to receive(:call).with(any_args()).and_return(list_response("4", error_message))
      expect{@subject.request_user_list("error")}.to raise_error(DatastreamClient::DatastreamError)
    end
  end

  describe "requesting a user list" do
    before(:each) do
      @list_symbol = 'list_symbol'
      instrument = "#{@list_symbol}~LIST~##{@username}"
      list_response = list_response(DatastreamClient::DatastreamClient::GOOD_STATUS, "", @econ_stat_symbol)
      allow(@soap_client).to receive(:call).with(:request_record,
                                                 message: request_message(@username, @password, @source, instrument))
                                           .and_return(list_response)
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

  describe "requesting an econ stat's details " do
    before(:each) do
      instrument = "#{@econ_stat_symbol}~REP~=GEOGN"
      @country = "AFGHANISTAN"
      response = stat_detail_response(@econ_stat_symbol, @country)
      allow(@soap_client).to receive(:call).with(:request_record,
                                                 message: request_message(@username, @password, @source, instrument))
                                           .and_return(response)
    end

    it "should obtain the country the stat is for" do
      econ_stat_details = @subject.request_symbol_details(@econ_stat_symbol)
      expect(econ_stat_details[:country]).to eq(@country)
    end

  end

  def request_message(username, password, source, instrument)
    { user: {username: "DS:" + username, password: password},
    request: {source: source, instrument: instrument},
    request_flags: 0}
  end

  def stat_detail_response(stat_symbol, country)
    field = [{:name=>"CCY", :value=>"NA"},
             {:name=>"DATE", :value=> 'some date'},
          # <DateTime: 2014-08-28T00:00:00+00:00 ((2456898j,0s,0n),+0s,2299161j)>},
             {:name=>"GEOGN", :value=> country },
             {:name=>"SYMBOL", :value=>"AFDCPI.."}]
    generic_response(field)
  end

  def list_response(status_code, status_message, stat_symbol = "anything")
    field = [{:name=>"LINK_1", :value=> stat_symbol},
             {:name=>"NAME_1", :value=>"AF CONSUMER PRICES (% CHANGE, AV) NADJ"},
             {:name=>"LINK_2", :value=>"AADCPI.."},
             {:name=>"NAME_2", :value=>"AA CONSUMER PRICES (% CHANGE, AV)"},
             {:name=>"REF_COUNT", :value=>"120"}]
    generic_response(field, status_code, status_message)
  end

  def generic_response(field, status_code = "0", status_message = "all good")
    OpenStruct.new(:body => {:request_record_response => {
        :request_record_result => {:status_code => status_code, :status_message => status_message,
          :fields => {
            :field => field
          }
        }
      }})

  end
end

#res.body[:request_record_response][:request_record_result][:fields][:field]
