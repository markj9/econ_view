require 'spec_helper'
module EconView
  describe EconomicIndicator do
    it "should be able to factory a list of indicators from config hash" do
      courier = double('courier')
      indicators = EconomicIndicator.create(courier: courier, config:{cpi: {high: 19, low: -20}, cab: {high: 'NA', low: -12}})
      expect(indicators.size).to eq(2)
      expect(indicators[0].low).to eq(-20)
      expect(indicators[0].courier).to eq(courier)
    end

    it "should factory by the specified class" do
      courier = double('courier')
      indicators = EconomicIndicator.create(courier: courier, config:{ fxdebt: {class_name: 'EconView::FXDebtIndicator' } })
      expect(indicators[0].is_a?(EconView::FXDebtIndicator)).to be_truthy
    end

    it "should convert code strings to lowercase symbols" do
      indicator = EconomicIndicator.new(name: :cpi, attrs: {code: "TSTD.."})
      expect(indicator.code).to eql(:"tstd..")
    end

    it "should have a threshold hash for a country which includes threshold" do
        @courier = double('courier')
        expect(@courier).to receive(:measurement_for).with(:cpi, :usa).
          and_return(EconomicMeasurement.new(:most_recent_value => 25))
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: :cpi, json_name: "CPI", high: 19})
        expect(indicator.threshold_value_for(:usa)).to eq({"CPI" => 25, "SumOfCPI" => EconomicIndicator::OUTSIDE_THRESHOLD})
    end

    describe "whether a measurement is outside the high/low threshold" do
      before :each do
        @courier = double('courier')
      end

      it "should be false if above high config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {high: 19})
        expect(indicator.within_threshold?(26)).to be_falsey
      end

      it "should handle 'NA' for a high config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {high: "NA"})
        expect(indicator.within_threshold?(15)).to be_truthy
      end

      it "should be false if below low config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {low: 30})
        expect(indicator.within_threshold?(10)).to be_falsey
      end

      it "should handle 'NA' for a low config" do
        indicator = EconomicIndicator.new(attrs: {low: "NA"})
        expect(indicator.within_threshold?(10)).to be_truthy
      end
    end
  end
end
