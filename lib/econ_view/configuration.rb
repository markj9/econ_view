module EconView
  class Configuration
    attr_accessor :datastream_username, :datastream_password, :economic_indicators, :user_lists

    def initialize(args)
      config_path = args[:config_path]
      config = YAML.load(ERB.new(File.read(config_path)).result)
      @datastream_username = config['datastream_username']
      @datastream_password = config['datastream_password']
      @economic_indicators = symbolize(config['economic_indicators'])
      @user_lists = config['user_lists']
    end


    private

    def symbolize(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << symbolize(v); memo
      end if obj.is_a? Array

      obj
    end
  end
end
