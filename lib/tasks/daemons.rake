namespace :ann do
  desc "Fetch weather data. This should be scheduled to run at a regular interval (10-60 min)"
  task :weather => :environment do
    # Loop through all active weather sensors
    Sensor.active.where(sensor_type: 'weather').each do |sensor|
      # address = '41.888194,-87.635412' # Lat/long for 1871
      lat, long = sensor.address.split(',')
      forecast = ForecastIO.forecast(lat, long, params: {exclude: 'minutely,hourly,daily,alerts,flags'})
      sensor.save_data(forecast.currently) if forecast
    end
  end

  desc "Chime the clock every hour"
  task :clock => :environment do
    Motor.where(personality: 'Weather').each do |m|
      curr_hour = Time.use_zone('America/Chicago') { Time.now.hour }
      curr_hour -= 12 if curr_hour > 12
      curr_hour = "0#{curr_hour}" if curr_hour < 10
      m.instructions.create!(content: "#{Instruction.convert_to_arduino_char('ACTION - CHIME')}#{curr_hour}")
    end
  end

  desc "Read 1871 tweet events"
  task :twitter_1871 => :environment do
    streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['1871_TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['1871_TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['1871_TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['1871_TWITTER_OAUTH_SECRET']
    end

    sensors = Sensor.active.select("DISTINCT ON (brain_id) *").where(sensor_type: 'twitter')

    streaming_client.user do |status|
      sensors.each { |sensor| sensor.save_data(status.name) } if status.is_a?(Twitter::Streaming::Event) && status.name == :follow
    end
  end

  desc "Read twitter user stream"
  task :twitter => :environment do
    streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['1871_TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['1871_TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['1871_TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['1871_TWITTER_OAUTH_SECRET']
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
    sensors = Sensor.active.select("DISTINCT ON (brain_id) *").where(sensor_type: 'twitter')

    topics = ['annsbrain']
    streaming_client.user(:track => topics.join(',')) do |status|
      # Loop through active twitter sensors
      sensors.each { |sensor| sensor.save_data(status.name) } if status.is_a?(Twitter::Streaming::Event) && status.name == :follow
      sensors.each { |sensor| sensor.save_data(status, status.to_h) } if status.is_a?(Twitter::Tweet) && status.to_h[:entities][:user_mentions].map{|u|u[:screen_name].downcase}.include?('annsbrain')
      ErrorMailer.error_report.deliver if Brain.first.try(:last_polled).try(:<, 5.minutes.ago) && Brain.first.try(:last_polled).try(:>, 5.minutes.ago - 20)
    end
  end
end
