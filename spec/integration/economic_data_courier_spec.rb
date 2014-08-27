# 1.  Read in a file of mneumonics for user economic lists to use to pull data.
# 2.  For each list mneumonic pull down the codes within the list.
# 3.  For each country mneumonic retrieve from datastream the economic measures and country information
# 4.  Persist all the economic indicators for each country.
require 'spec_helper.rb'

describe EconomicDataCourier do
  describe "retrieving datastream data" do
    it "should take a path to a file containing mneumonics for user economic lists" do
      subject = EconomicDataCourier.new datastream_list_path: '../input/datastream_lists.yml'
      expect(subject.datastream_user_lists).not_to be_empty
    end
  end
end

