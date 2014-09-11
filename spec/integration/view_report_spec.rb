# 1.  The report is configured with a list of Economic Indicators.  Each Economic Indicator corresponds to a
# datastream user list containing a code for each country's measurement for the corresonding economic indicator.
# 2.  For each of its economic indicators it will pull the most current value for every country in the list.
# 3.  For all the countries in all of its Economic Indicators it will compute a risk score.
# 4.  It will then export out JSON for all of the countries in its Economic Indicators the risk score and the most recent
# value for each economic indicator.
require 'spec_helper'
require 'JSON'
module EconView
describe ViewReport do
  it "should generate JSON with a risk score" do
    VCR.use_cassette('datastream') do
      config = Configuration.new config_path: 'lib/config/config.yml'
      client = DatastreamClient::DatastreamClient.new(username: config.datastream_username, password: config.datastream_password)
      courier = EconomicDataCourier.new(client: client, user_lists: config.user_lists)
      indicators = EconomicIndicator.create(courier: courier, config: config.economic_indicators)
      report = ViewReport.new(courier: courier, economic_indicators: indicators)
      report.extend(ViewReportRepresenter)
      report.build
      json = report.to_json
      expect(json).not_to be_nil
      json_hash = JSON.parse(json)
      venezuela_row = extract_row_for(json_hash, "Venezuela")
      expect(venezuela_row).to include(venezuela_expected_result)
    end
  end

  def extract_row_for(json, country)
    json["country_list"].each do |row|
      return row if row["CountryName"] == country
    end
    nil
  end

  def venezuela_expected_result
    {
      "SumOfFXImports"=> 0.0,
      "FXImports"=> 3.5,
      "SumOfRealGDP"=> 1.0,
      "RealGDP"=> -2.5,
      "SumOfCPI"=> 1.0,
      "CPI"=> 64.4,
      "SumOfRealSTLR"=> 1.0,
      "RealSTLR"=> -28.5,
      "SumOfFB"=> 1.0,
      "FB"=> -12.2,
      "SumOfRDCG"=> 0.0,
      "RDCG"=> 16.1,
      "SumOfFXDebt"=> 1.0,
      "FXDebt"=> 24.1,
      "SumOfCAB"=> 0.0,
      "CAB"=> 1.6,
#      "TimePeriod"=> 2014,
      "CountryName"=> "Venezuela",
#      "RiskScore"=> 5.0
      "RiskScore"=> 5
     }
  end
end
end
