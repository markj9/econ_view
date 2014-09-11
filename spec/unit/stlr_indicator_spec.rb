require 'spec_helper'

module EconView
describe STLRIndicator do

  let(:courier) { double("courier") }
  subject { STLRIndicator.new(attrs: {courier: courier}) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"lrat..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => lrat)) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"dcpi..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => cpi)) }

  let(:lrat) { 17.5 }
  let(:cpi) { 64.4 }
  it "should compute value based off (Lending Interest Rate/100 +1)/(CPI/100 + 1) * 100 - 100" do
   expect(subject.compute_value(:venezuela)).to eq(-28.5)
  end
end
end
