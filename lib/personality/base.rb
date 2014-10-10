module Personality
  class Base
    def react(motor, sensor_type, data)
      # Announcements override all individual personality behaviors
      if sensor_type == 'twitter' && 
          data.entities.hashtags.include?('announcement') && 
          # Whitelist monkeybars staff, 1871, cisco, and myself to be able to post #announcements
          data.user.screen_name.downcase.in?(['monkeybars_chi', 'neilgupta', '1871chicago', 'ciscogeeks', 'cisco_iot', 'amadeus98', 'doitjay'])
        # Retweet announcement
        twitter_client.retweet([data])
        # Send flocks into alert mode!
        return 'ACTION - ALERT'
      end

      # Generate individual personality reactions
      generate_reaction(motor, sensor_type, data)
    end

    def generate_reaction(motor, sensor_type, data)
      raise NotImplementedError.new("#{__method__} not implemented in #{self.class.name}")
    end

    def twitter_client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
        config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
      end
    end
  end
end
