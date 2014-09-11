class ViewReportController
  attr_accessor :config

  def initialize(args)
    raise Exception.new("Invalid config") if args[:config].nil?
    @config = args[:config]
    build
  end

  def build
        config = EconView::Configuration.new config_path: @config
        client = DatastreamClient::DatastreamClient.new(username: config.datastream_username, password: config.datastream_password)
        courier = EconView::EconomicDataCourier.new(client: client, user_lists: config.user_lists)
        indicators = EconView::EconomicIndicator.create(courier: courier, config: config.economic_indicators)
        report = EconView::ViewReport.new(courier: courier, economic_indicators: indicators)
        report.write_json_to_file
  end
end
