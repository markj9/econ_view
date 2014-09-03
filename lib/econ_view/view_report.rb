module EconView
  class ViewReport
    attr_reader :countries, :economic_indicators
    def initialize(args)
      @countries = []
      @economic_indicators = args[:economic_indicators]
      args[:economic_indicators].each {|i| @countries << i.countries }
      @countries.flatten!.uniq!.sort!
    end

    def to_json
      risk_score = 0
      country_list = []
      countries.each do |country|
        country_result = {}
        @economic_indicators.each do |indicator|
          values = indicator.json_values_for(country)
          threshold_value = values["SumOf"+ indicator.json_name]
          if threshold_value == 1
            risk_score += 1
          end
          country_result.merge!(values)
        end
        country_result["RiskScore"] = risk_score
        country_result["CountryName"] = country.to_s.capitalize
        country_list << country_result
      end
      {"country_list" => country_list.to_json }.to_json
    end
  end
end
