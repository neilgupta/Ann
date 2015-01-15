class WeatherEngine
  def self.generate
    # address = '41.888194,-87.635412' # Lat/long for 1871
    forecast = ForecastIO.forecast('41.888194', '-87.635412', params: {exclude: 'minutely,hourly,daily,alerts,flags'})
    data = forecast.currently

    if data.precipProbability > 0.7
      "It's #{data.temperature} degrees. Also, looks like there's a #{data.precipProbability}% chance of rain... Hope you have an umbrella!"
    elsif data.cloudCover > 0.8 || data.visibility < 3
      "It's #{data.temperature} and cloudy. I miss the sun..."
    elsif data.temperature > 80
      "It's burning up at #{data.temperature}... I think I'll stay inside today!"
    elsif data.temperature > 60
      "It's a nice #{data.temperature}! :)"
    elsif data.temperature > 30
      "It's only #{data.temperature}... Don't forget to wear a jacket!"
    elsif data.temperature <= 30
      "It's freezing at #{data.temperature} degrees... Why do I live in this city?"
    end
  end
end
