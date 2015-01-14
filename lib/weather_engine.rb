class WeatherEngine
  def self.generate
    # address = '41.888194,-87.635412' # Lat/long for 1871
    forecast = ForecastIO.forecast('41.888194', '-87.635412', params: {exclude: 'minutely,hourly,daily,alerts,flags'})
    data = forecast.currently

    if data.precipProbability > 0.7
      "Looks like it's wet outside..."
    elsif Time.now > night && Time.now < dawn
      "Who cares? It's too dark to tell!"
    elsif Time.now > dawn && Time.now < morning
      "Rise and shine buttercup!"
    elsif data.cloudCover > 0.8 || data.visibility < 3
      "Blegh it's so cloudy. I think I'll stay inside today!"
    elsif data.temperature > 70
      "Wooo it's sunny! Let's go to the beach!"
    elsif data.temperature > 30
      "Brrrr it's cold :("
    elsif data.temperature <= 30
      "It's below freezing... Why do I live in this city?"
    end
  end

  def self.dawn
    gen_time_with_hour(5)
  end

  def self.morning
    gen_time_with_hour(8)
  end

  def self.afternoon
    gen_time_with_hour(12)
  end

  def self.evening
    gen_time_with_hour(16)
  end

  def self.night
    gen_time_with_hour(20)
  end

  def self.midnight
    gen_time_with_hour(23)
  end

  def self.gen_time_with_hour(hour)
    Time.use_zone('America/Chicago') {Time.now.change(hour: hour, min: 0)}
  end
end
