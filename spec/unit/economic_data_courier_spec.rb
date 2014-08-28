require 'spec_helper'

describe EconView::EconomicDataCourier do
  describe "retrieving a user list" do
    it "should request the list of symbols" do
      client = double("datastream_client")
      list_symbol = 'list'
      expect(client).to receive(:request_user_list).with(list_symbol).and_return([])
      subject = EconView::EconomicDataCourier.new(client: client)
      subject.retrieve_datastream_user_list(list_symbol)
    end

    it "should request the country for each item in the list" do
      client = double("datastream_client")
      list_symbol = 'list'
      allow(client).to receive(:request_user_list).with(list_symbol).and_return([{symbol: "AFGCPI", description: "AFG CPI"}])
      expect(client).to receive(:request_symbol_details).with("AFGCPI").and_return({country: "Afghanistan"})
      subject = EconView::EconomicDataCourier.new(client: client)
      user_list = subject.retrieve_datastream_user_list(list_symbol)
      expect(user_list[0].country).to eq("Afghanistan")
    end
  end
end
