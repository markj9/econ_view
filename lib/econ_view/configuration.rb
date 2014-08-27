module EconView
  class Configuration
    attr_accessor :datastream_username, :datastream_password

    def initialize
      @datastream_username = 'admin'
    end
  end
end
