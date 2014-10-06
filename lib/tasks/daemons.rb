namespace :ann do
  desc "Fetch weather data. This should be scheduled to run at a regular interval (10-60 min)"
  task :weather => :environment do
    # Loop through all active weather sensors
    Sensor.active.where(type: 'weather').each do |sensor|
      # address = '41.888194,-87.635412' # Lat/long for 1871
      lat, long = sensor.address.split(',')
      forecast = ForecastIO.forecast(lat, long, params: {exclude: 'minutely,hourly,daily,alerts,flags'})
      sensor.save_data(forecast.currently) if forecast
    end
  end

  desc "Read twitter user stream"
  task :twitter => :environment do
    streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
    end

    # Fetch one twitter sensor per brain and store in memory before streaming.
    # 
    # This design requires us to restart the twitter daemon whenever a twitter 
    # sensor is added or removed. Since this is also only able to follow a
    # single twitter account, each brain should not have more than one twitter
    # sensor, or else there will be duplicate inputs.
    #
    # Eventually (aka Ideally), each twitter stream should be an individual 
    # daemonized process that can be stopped and started on the fly, as well 
    # as set to follow different twitter accounts.
    # 
    # For now, I will settle for just randomly picking one twitter sensor per brain.
    sensors = Sensor.active.select("DISTINCT ON (brain_id) *").where(type: 'twitter')

    topics = ['iotwfhack', 'hashtag2']
    streaming_client.user(:track => topics.join(',')) do |status|
      # Loop through active twitter sensors
      sensors.each { |sensor| sensor.save_data(status, status.to_h) } if status.is_a?(Twitter::Tweet)
    end
  end
end
