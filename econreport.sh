#!/usr/bin/env ruby
$LOAD_PATH << '.'
require 'optparse'
Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each {|f| require f}

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: viewreport COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     generate:  Generate the economic view report"
  opt.separator  ""
  opt.separator  "Options"
  
  options[:config] = 'lib/config/config.yml'
  opt.on("-c","--config CONFIG","path to the report configuration") do |config|
    options[:config] = config
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

case ARGV[0]
when "generate"
  puts "called generate on options #{options.inspect}"
  ViewReportController.new(options)
else
  puts opt_parser
end
