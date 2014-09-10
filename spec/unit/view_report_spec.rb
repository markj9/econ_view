require 'spec_helper'
require 'JSON'
module EconView
  describe ViewReport do
    it "should obtain a deduped list of countries from the data courier" do
      courier = double('courier')
      expect(courier).to receive(:countries).and_return([:afghanistan, :algiers, :venezuela])
      report = ViewReport.new(courier: courier)
      expect(report.countries).to eq([:afghanistan, :algiers, :venezuela])
    end

    it "should build a country list for each country" do
      courier = double('courier')
      expect(courier).to receive(:countries).and_return([:usa])
      cpi = double('cpi')
      expect(cpi).to receive(:json_name).and_return("CPI")
      expect(cpi).to receive(:threshold_value_for).with(:usa).and_return({"CPI" => 64.1, "SumOfCPI" => 1.0})
      cab = double('cab')
      expect(cab).to receive(:json_name).and_return("CAB")
      expect(cab).to receive(:threshold_value_for).with(:usa).and_return({"CAB" => 5, "SumOfCAB" => 1.0})
      report = ViewReport.new(courier: courier, economic_indicators: [cpi, cab])
      report.extend(ViewReportRepresenter)
      report.build
      json = JSON.parse(report.to_json)
      correct_result = <<END
                  {"country_list": [{"CPI":  64.1, "SumOfCPI": 1.0, "CAB": 5, "SumOfCAB": 1.0,
                                            "CountryName": "Usa", "RiskScore": 2}] }
END
     expect(json).to eql(JSON.parse(correct_result))
   end
  end
end
