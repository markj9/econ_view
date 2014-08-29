require 'pry'
require 'vcr'
#Dir[File.join(File.dirname(__FILE__), "../lib/**/*.rb")].each {|f| require f}
require 'econ_view'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
VCR.configure do |c|
  c.hook_into :webmock
  c.ignore_hosts 'www.some-url.com'
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.cassette_library_dir                    = 'spec/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options                = { allow_playback_repeats: true, match_requests_on: [:method, :uri, :headers] }
  c.debug_logger                            = File.open('log/vcr.log', 'w')
end
