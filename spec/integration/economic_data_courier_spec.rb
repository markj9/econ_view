# 1.  Read in a file of mneumonics for user economic lists to use to pull data.
# 2.  For each list mneumonic pull down the codes within the list.
# 3.  For each country mneumonic retrieve from datastream the economic measures and country information
# 4.  For each country and each economic measure compute the threshold value.
# 5.  For each country using the threshold values compute a risk score.
# 6.  Write out JSON data for each country.
require 'spec_helper'

describe EconView::EconomicDataCourier do
  it "should retrieve a list of country specific mnemonics for an economic measure from a user list mnemonic" do
    config = EconView::Configuration.new config_path: 'lib/config/config.yml'
    client = DatastreamClient::DatastreamClient.new(username: config.datastream_username, password: config.datastream_password)
    courier = EconView::EconomicDataCourier.new(client: client)
    VCR.use_cassette('datastream') do
      expect(courier.retrieve_datastream_user_list('L#H19599')[:venezuela].most_recent_value).to eql('64.4')
    end
  end
end

