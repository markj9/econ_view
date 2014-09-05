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

    it "should have a list of countries that it has measurements for" do
      courier = double('courier')
      expect(courier).to receive(:retrieve_datastream_user_list).with("xyz").and_return(:usa => {}, :russia => {})
      indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: courier, code: "xyz"})
      expect(indicator.countries).to eql([:usa, :russia])
    end

    it "should have measurements_for a country which includes threshold" do
        @courier = double('courier')
        expect(@courier).to receive(:retrieve_datastream_user_list).with("xyz").
          and_return(:usa => OpenStruct.new(:most_recent_value => 25))
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: "xyz", json_name: "CPI", high: 19})
        expect(indicator.measurements_for(:usa)).to eq({"CPI" => 25, "SumOfCPI" => EconomicIndicator::OUTSIDE_THRESHOLD})
    end

    describe "wether a measurement is outside the high/low threshold" do
      before :each do
        @courier = double('courier')
        allow(@courier).to receive(:retrieve_datastream_user_list).with("xyz").
          and_return(:usa => OpenStruct.new(:most_recent_value => 25))
      end

      it "should be false if above high config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: "xyz", high: 19})
        expect(indicator.within_threshold?(:usa)).to be_falsey
      end

      it "should handle 'NA' for a high config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: "xyz", high: "NA"})
        expect(indicator.within_threshold?(:usa)).to be_truthy
      end

      it "should be false if below low config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: "xyz", low: 30})
        expect(indicator.within_threshold?(:usa)).to be_falsey
      end

      it "should handle 'NA' for a low config" do
        indicator = EconomicIndicator.new(name: :cpi, attrs: {courier: @courier, code: "xyz", low: "NA"})
        expect(indicator.within_threshold?(:usa)).to be_truthy
      end
    end
  end
end
