require 'spec_helper'

module EconView
  describe Configuration do
    describe "#datastream_username" do
      it "should load configuration file data" do
        config = Configuration.new(config_path: 'spec/config/config.yml')
        expect(config.datastream_username).to eq('admin')
      end
    end
  end
end
