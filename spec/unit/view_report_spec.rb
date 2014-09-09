require 'spec_helper'
require 'JSON'
module EconView
  describe ViewReport do
    it "should obtain a deduped list of countries from the data courier" do
      courier = double('courier')
      expect(courier).to receive(:countries).and_return([:afghanistan, :algiers, :venezuela])
      report = ViewReport.new(courier: courier)
      expect(report.countries).to eq([:afghanistan, :algiers, :greece, :venezuela])
    end

#    it "should generate json for each country" do
#      cpi = double('cpi')
#      expect(cpi).to receive(:countries).and_return([:afghanistan])
#      expect(cpi).to receive(:json_name).and_return("CPI")
#      expect(cpi).to receive(:measurements_for).with(:afghanistan).and_return({"CPI" => 64.1, "SumOfCPI" => 1.0})
#      cab = double('cab')
#      expect(cab).to receive(:countries).and_return([:afghanistan])
#      expect(cab).to receive(:json_name).and_return("CAB")
#      expect(cab).to receive(:measurements_for).with(:afghanistan).and_return({"CAB" => 5, "SumOfCAB" => 1.0})
#      report = ViewReport.new(economic_indicators: [cpi, cab])
#      report.extend(ViewReportRepresenter)
#      report.build
#      json = JSON.parse(report.to_json)
#      correct_result = <<END
#                  {"country_list": [{"CPI":  64.1, "SumOfCPI": 1.0, "CAB": 5, "SumOfCAB": 1.0,
#                                            "CountryName": "Afghanistan", "RiskScore": 2}] }
#END
#     expect(json).to eql(JSON.parse(correct_result))
#    end
  end
end
