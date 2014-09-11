require 'spec_helper'

module EconView
describe RDCGIndicator do

  let(:courier) { double("courier") }
  subject { RDCGIndicator.new(attrs: {courier: courier}) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"sodd..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => rdcg)) }
  before {  expect(courier).to receive(:measurement_for).
            with(:"dcpi..", :venezuela).
            and_return(EconomicMeasurement.new(:most_recent_value => cpi)) }

  let(:rdcg) { 90.9 }
  let(:cpi) { 64.4 }
  it "should compute value based off (DOMESTIC CREDIT GROWTH/100 +1)/(CPI/100 + 1) * 100 - 100" do
   expect(subject.compute_value(:venezuela)).to eq(16.1)
  end
end
end
