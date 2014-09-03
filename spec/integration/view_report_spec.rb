# 1.  The report is configured with a list of Economic Indicators.  Each Economic Indicator corresponds to a
# datastream user list containing a code for each country's measurement for the corresonding economic indicator.
# 2.  For each of its economic indicators it will pull the most current value for every country in the list.
# 3.  For all the countries in all of its Economic Indicators it will compute a risk score.
# 4.  It will then export out JSON for all of the countries in its Economic Indicators the risk score and the most recent
# value for each economic indicator.
require 'spec_helper'
module EconView
describe ViewReport do
  it "should generate JSON with a risk score" do
    config = Configuration.new config_path: 'lib/config/config.yml'
    client = DatastreamClient::DatastreamClient.new(username: config.datastream_username, password: config.datastream_password)
    courier = EconomicDataCourier.new(client: client)
    indicators = EconomicIndicator.create(courier: courier, config: config.economic_indicators)
    report = ViewReport.new(economic_indicators: indicators)
    VCR.use_cassette('datastream') do
      expect(report.to_json).to include("\"RiskScore\": 5")
    end
  end
end
end
