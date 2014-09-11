module EconView
  class FXDebtIndicator < EconomicIndicator
    FOREIGN_EXCHANGE_RESERVES = :"fres.."
    SHORT_TERM = :"tstd.."

    def compute_value(country)
      fx_reserves = courier.measurement_for(FOREIGN_EXCHANGE_RESERVES, country)
      short_term = courier.measurement_for(SHORT_TERM, country)
      if !valid_measurement?(fx_reserves) || !valid_measurement?(short_term) || short_term.most_recent_value.to_f == 0
        return nil
      end
      result = (fx_reserves.most_recent_value.to_f/short_term.most_recent_value.to_f) * 100
      result.round(1)
    end
  end
end
