require 'spec_helper'

module EconView
describe FXDebtIndicator do

  let(:courier) { double("courier") }
  subject { FXDebtIndicator.new(attrs: {courier: courier}) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"fres..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => fres_value)) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"tstd..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => short_term_value)) }

  let(:fres_value) { 4.124 }
  let(:short_term_value) { 17.126 }
  it "should compute value based off (Foreign-Exchange Reserves/Short Term) * 100" do
   expect(subject.compute_value(:venezuela)).to eq(24.1)
  end

  describe "short term being zero " do
    let(:short_term_value) { 0 }
    it "should return nil if short term is 0 to avoid division by 0" do
     expect(subject.compute_value(:venezuela)).to be_nil
    end
  end
end
end
