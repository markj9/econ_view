module EconView
  class STLRIndicator < EconomicIndicator
    LENDING_INTEREST_RATE = :"lrat.."

    def compute_value(country)
      lending_interest_rate = courier.measurement_for(LENDING_INTEREST_RATE, country)
      cpi = courier.measurement_for(CPI, country)
      if !valid_measurement?(lending_interest_rate) || !valid_measurement?(cpi)
        return nil
      end
      result = (lending_interest_rate.most_recent_value.to_f/100 + 1)/(cpi.most_recent_value.to_f/100 + 1) * 100 -100
      result.round(1)
    end
  end
end
