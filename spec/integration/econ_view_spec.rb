require 'spec_helper'

describe EconView do
  describe "#configure" do
    before do
      EconView.configure do |config|
        config.datastream_username = 'markj9'
      end
    end

    it "should configure the datastream client" do
      client = EconView::EconomicDataCourier.new.datastream_client
      expect(client.username).to eq('markj9')
    end
  end
end
