module EconView
  require 'representable/json'

  class ViewReportRepresenter < Representable::Decorator
    include Representable::JSON

  #  property :title
  #  property :track
    property :name
    property :year, as: "TimePeriod"
    collection :country_list
  end

  class ViewReport
    attr_reader :name, :year, :countries, :economic_indicators, :country_list
    def initialize(args)
      @countries = args[:courier].countries
      @name = args.fetch(:name, "ViEWCountrySet")
      @year = args.fetch(:year, 2014)
      @economic_indicators = args.fetch(:economic_indicators, [])
      build
    end

    def write_json_to_file
      presenter = ViewReportRepresenter.new(self)
      out = File.open('data/view_report.json', 'w')
      out.write(presenter.to_json)
      out.close
    end

    private
    def build
      @country_list = []
      countries.each do |country|
        country_result = {}
        risk_score = 0
        @economic_indicators.each do |indicator|
          values = indicator.threshold_value_for(country)
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

