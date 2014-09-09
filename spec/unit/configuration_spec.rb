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
      expect(@config.economic_indicators.size).to eq(8)
    end

    it "should have an array of user lists" do
      expect(@config.user_lists.size).to eq(8)
    end
  end
end
