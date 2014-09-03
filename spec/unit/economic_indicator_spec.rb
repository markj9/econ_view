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
  end
end
