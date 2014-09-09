require 'spec_helper'
module EconView
describe EconomicDataCourier do
  describe "initializing measurements when given user lists" do
    before :each do
      @client = double("datastream_client")
      @list_symbol = 'list'
      @code = :gcpi
      @country = :afghanistan
      @value = 64.1
      allow(@client).to receive(:request_user_list).with(@list_symbol).
        and_return([{symbol: "AF#{@code.to_s.upcase}"}])
      allow(@client).to receive(:request_symbol_details).with("AFGCPI").and_return({country: "Afghanistan"})
      allow(@client).to receive(:request_stat_measurements).with("AFGCPI", 3).and_return(OpenStruct.new(
        :most_recent_value => @value))
    end

    it "should have a measurement by indicator code and country" do
      subject = EconomicDataCourier.new(client: @client, user_lists: ['list'])
      expect(subject.measurement_for(@code, @country).most_recent_value).to eq(@value)
    end

    describe "retrieving a user list with an invalid item in the list" do
      it "should produce a nil measurement" do
        allow(@client).to receive(:request_symbol_details).with("AFGCPI").
          and_raise(DatastreamClient::DatastreamError.new("Some Error"))
        expect(subject.measurement_for(@code, @country).most_recent_value).to be_nil
      end
    end
  end
end
end
