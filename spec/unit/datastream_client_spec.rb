require 'spec_helper'
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
    allow(@soap_client).to receive(:call).with(:request_record,
                                              message: request_message(@username, @password, @source, instrument))
                                         .and_return(response)
 end

  describe "invalid status" do
    let(:instrument) { "error~LIST~#test" }
    let(:response) { list_response("4", "invalid request" ) }
    it "should raise a datastream error" do
      expect{@subject.request_user_list("error")}.to raise_error(DatastreamClient::DatastreamError)
    end
  end

  describe "requesting a user list" do
    let(:list_symbol) { 'list_symbol' }
    let(:response) { list_response(DatastreamClient::DatastreamClient::GOOD_STATUS, "", @econ_stat_symbol) }
    let(:instrument) { "#{list_symbol}~LIST~##{@username}" }
    it "should request a user list" do
      expect(@soap_client).to receive(:call)
      @subject.request_user_list(list_symbol)
    end

    it "should return an array of hashes containing econ statistics" do
      econ_stats = @subject.request_user_list(list_symbol)
      expect(econ_stats[0][:symbol]).to eq(@econ_stat_symbol)
    end

  end

  describe "requesting an econ stat's details " do
    let(:country) { "AFGHANISTAN" }
    let(:response) { stat_detail_response(@econ_stat_symbol, country) }
    let(:instrument) {"#{@econ_stat_symbol}~REP~=GEOGN" }
    it "should obtain the country the stat is for" do
      econ_stat_details = @subject.request_symbol_details(@econ_stat_symbol)
      expect(econ_stat_details[:country]).to eq(country)
    end
  end

  describe "requesting an econ stat's values" do
    let(:years_back) { 3 }
    let(:response) { stat_measurement_response() }
    let(:instrument) {"#{@econ_stat_symbol}~-#{years_back}Y" }
    it "should return the most recent measurement value" do
      econ_stat_measurements = @subject.request_stat_measurements(@econ_stat_symbol, years_back)
      expect(econ_stat_measurements.most_recent_value).to eq("NaN")
    end

#    describe "handling an error for no econ data" do
#      let(:response) { list_response("2", "$$\"ER\", 0628, MBDCPI..  NO ECONOMIC DATA") }
#      it "should return nil when the message is has no econ data" do
#        econ_stat_measurements = @subject.request_stat_measurements(@econ_stat_symbol, years_back)
#        expect(econ_stat_measurements).to be_nil()
#      end
#    end

    describe "handling an error for invalid request" do
      let(:response) { list_response("4", "invalid request" ) }
      it "should throw a DatastreamError if not a No Economic Data message" do
        expect{ @subject.request_stat_measurements(@econ_stat_symbol, years_back) }.to raise_error(DatastreamClient::DatastreamError)
      end
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

  def stat_measurement_response()
    field = [{:name=>"CCY", :value=>{:"@xsi:type"=>"xsd:string"}},
    {:name=>"DATE", :array_value=>
      {:any_type=>[DateTime.parse('2011-06-30T00:00:00+00:00'),
             DateTime.parse('2012-06-30T00:00:00+00:00'),
             DateTime.parse('2013-06-30T00:00:00+00:00'),
             DateTime.parse('2014-06-30T00:00:00+00:00')]
      }
    },
    {:name=>"DISPNAME", :value=>"AF CONSUMER PRICES (% CHANGE, AV) NADJ"},
    {:name=>"FREQUENCY", :value=>"Y"},
    {:name=>"P", :array_value=>{:any_type=>["10.2", "7.23", "7.65", "NaN"]}},
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
