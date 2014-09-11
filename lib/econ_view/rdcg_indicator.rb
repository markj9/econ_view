module EconView
class RDCGIndicator < EconomicIndicator
  DOMESTIC_CREDIT_GROWTH = :"sodd.."

  def compute_value(country)
    domestic_credit_growth = courier.measurement_for(DOMESTIC_CREDIT_GROWTH, country)
    cpi = courier.measurement_for(CPI, country)
    if !valid_measurement?(domestic_credit_growth) || !valid_measurement?(cpi)
      return nil
    end
    result = (domestic_credit_growth.most_recent_value.to_f/100 + 1)/(cpi.most_recent_value.to_f/100 + 1) * 100 -100
    result.round(1)
  end
end
end
