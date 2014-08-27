require 'spec_helper'

module EconView
  describe Configuration do
    describe "#datastream_username" do
      it "should default to 'admin'" do
        config = Configuration.new
        expect(config.datastream_username).to eq('admin')
      end
    end
  end
end
