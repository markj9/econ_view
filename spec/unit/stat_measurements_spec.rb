require 'spec_helper'

module DatastreamClient
describe StatMeasurements do
  it "should raise a datastream error if dates and values are not the same size" do
    expect{StatMeasurements.new(dates: [0, 1], values: [0])}.to raise_error(DatastreamError)
  end

  it "should has its data" do
    values = [12, 13]
    dates = [0, 1]
    subject = StatMeasurements.new(dates: dates, values: values)
    hash = subject.to_h
    expect(hash[:values]).to eq(values)
  end
end
end
