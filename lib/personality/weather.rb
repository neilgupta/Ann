module Personality
  class Weather < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'weather'

      if data.precipProbability > 0.7
        'WEATHER - RAINY'
      elsif Time.now > night && Time.now < dawn
        'WEATHER - DARK'
      elsif Time.now > dawn && Time.now < morning
        'WEATHER - SUNRISE'
      elsif data.cloudCover > 0.8 || data.visibility < 3
        'WEATHER - CLOUDY'
      elsif data.temperature > 70
        'WEATHER - SUNNY'
      elsif data.temperature > 30
        'WEATHER - COLD'
      elsif data.temperature <= 30
        'WEATHER - SNOWY'
      end
    end

    def dawn
      gen_time_with_hour(5)
    end

    def morning
      gen_time_with_hour(8)
    end

    def afternoon
      gen_time_with_hour(12)
    end

    def evening
      gen_time_with_hour(16)
    end

    def night
      gen_time_with_hour(20)
    end

    def midnight
      gen_time_with_hour(23)
    end

    def gen_time_with_hour(hour)
      Time.use_zone('America/Chicago') {Time.now.change(hour: hour, min: 0)}
    end
  end
end
