module EconView
  class ViewReport
    attr_reader :countries, :economic_indicators, :country_list
    def initialize(args)
      @countries = []
      @economic_indicators = args[:economic_indicators]
      args[:economic_indicators].each {|i| @countries << i.countries }
      @countries.flatten!.uniq!.sort!
    end

    def build
      @country_list = []
      countries.each do |country|
        country_result = {}
        risk_score = 0
        @economic_indicators.each do |indicator|
          values = indicator.measurements_for(country)
          threshold_value = values["SumOf"+ indicator.json_name]
          if threshold_value == EconomicIndicator::OUTSIDE_THRESHOLD
            risk_score += 1
          end
          country_result.merge!(values)
        end
        country_result["RiskScore"] = risk_score
        country_result["CountryName"] = country.to_s.capitalize
        @country_list << country_result
      end
    end
  end
end

require 'representable/json'

module ViewReportRepresenter
  include Representable::JSON

#  property :title
#  property :track
  collection :country_list
end
