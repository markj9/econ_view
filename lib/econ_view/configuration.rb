module EconView
  class Configuration
    attr_accessor :datastream_username, :datastream_password

    def initialize(args)
      config_path = args[:config_path]
      config = YAML.load(ERB.new(File.read(config_path)).result)
      @datastream_username = config['datastream_username']
      @datastream_password = config['datastream_password']
    end
  end
end
