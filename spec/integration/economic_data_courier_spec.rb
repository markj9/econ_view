# 1.  Read in a file of mneumonics for user economic lists to use to pull data.
# 2.  For each list mneumonic pull down the codes within the list.
# 3.  For each country mneumonic retrieve from datastream the economic measures and country information
# 4.  Persist all the economic indicators for each country.
require 'spec_helper'

describe EconView::EconomicDataCourier do
  it "should retrieve a list of a symbols from a user list mneumonic" do
    config = EconView::Configuration.new
    config.datastream_username = 'test'
    config.datastream_password = 'test'
    courier = EconView::EconomicDataCourier.new(client: DatastreamClient::DatastreamClient.new(username: config.datastream_username))
    expect(courier.retrieve_datastream_user_list('L#H19599')).to_not be_empty
  end
end

