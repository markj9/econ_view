require 'spec_helper'

module EconView
  describe Configuration do
    before :each do
      @config = Configuration.new(config_path: 'spec/config/config.yml')
    end

    it "should parse the datastream username" do
      expect(@config.datastream_username).to eq('admin')
    end

    it "should have a hash of economic indicators" do
      expect(@config.economic_indicators.size).to eq(2)
    end

    it "should have a code for each economi_indicator" do
      expect(@config.economic_indicators[:cpi][:code]).to eql("L#H19599")
    end
  end
end
