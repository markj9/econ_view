require 'spec_helper'

describe EconView::EconomicDataCourier do
  describe "retrieving a user list" do
    before :each do
      @client = double("datastream_client")
      @list_symbol = 'list'
      allow(@client).to receive(:request_user_list).with(@list_symbol).and_return([{symbol: "AFGCPI", description: "AFG CPI"}])
      allow(@client).to receive(:request_symbol_details).with("AFGCPI").and_return({country: "Afghanistan"})
      allow(@client).to receive(:request_stat_measurements).with("AFGCPI", 3)
    end

    it "should request the list of symbols" do
      expect(@client).to receive(:request_user_list).with(@list_symbol).and_return([])
      subject = EconView::EconomicDataCourier.new(client: @client)
      subject.retrieve_datastream_user_list(@list_symbol)
    end

    it "should request the country for each item in the list" do
      expect(@client).to receive(:request_symbol_details).with("AFGCPI").and_return({country: "Afghanistan"})
      subject = EconView::EconomicDataCourier.new(client: @client)
      user_list = subject.retrieve_datastream_user_list(@list_symbol)
      expect(user_list[:afghanistan].country).to eq("Afghanistan")
    end

    it "should request the measurements for each country" do
      expect(@client).to receive(:request_stat_measurements).with("AFGCPI", 3)
        .and_return(OpenStruct.new(most_recent_value: "8.0"))
      subject = EconView::EconomicDataCourier.new(client: @client)
      user_list = subject.retrieve_datastream_user_list(@list_symbol)
      expect(user_list[:afghanistan].most_recent_value).to eq('8.0')
    end
  end
end
