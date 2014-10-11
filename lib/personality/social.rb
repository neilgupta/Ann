module Personality
  class Social < Base
    def generate_reaction(motor, sensor_type, data)
      # Reply to tweets or generate tweets depending on other sensor data
      if sensor_type == 'twitter' && data.entities.user_mentions.include?('annsbrain')
        # Don't respond to this tweet if it's captured by API
        return if Api.generate_reaction(motor, sensor_type, data)

        user = data.user.screen_name

        response = case data.text
        when /marry me/i then 'Sorry, I don\'t think that\'s been legalized yet.'
        when /meaning of life/i then 'All evidence to date suggests it\'s tacos.'
        when /knock knock/i then "Knock knock. Who's there? #{user}. #{user} who? #{user}, I don't do knock-knock jokes."
        when /who let the dogs out/i then 'Who? Who? Who? Who? Who?'
        when /talk dirty/i then 'Humus. Compost. Pumice. Silt. Gravel.'
        when /joke/i then JokeEngine.generate(user)
        else # Fallback to relying on cleverbot
          # Find this user's chat history
          cb = motor.brain.cleverbots.find_or_create_by!(username: user)
          
          # Generate response
          res = cb.think(data.text)

          # Save bot backlog
          cb.save!

          res
        end

        # Tweet response
        twitter_client.update("@#{user} #{response}", {in_reply_to_status: data}) if response

        return 'ACTION - NOD'
      # elsif sensor_type == 'motion'
      #   # If motion data is significantly higher or lower than usual, comment about it
      #   q = ActiveRecord::Base.connection.select_all("
      #     with series as (
      #       select generate_series(current_timestamp - interval '3 hours', current_timestamp, '10 minutes') :: date as date
      #     )

      #     select s.date as date, count(i.id) as count
      #       from series s, inputs i
      #       inner join sensors sensor on i.sensor_id = sensor.id and sensor.brain_id = s.brain_id
      #       inner join brains b on b.id = sensor.brain_id
      #       inner join motors m on m.brain_id = b.id
      #       where m.id = #{motor.id}
      #         and i.created_at > s.date and i.created_at < s.date + interval '10 minutes'
      #       group by s.date
      #       order by count(i.id) desc
      #   ").to_ary[0]
      #   Input.joins(sensor: [brain: :motor]).select("generate_series(brains.activated_at, current_timestamp, '10 minutes'), count(inputs.id)").where("motors.id = ? and sensors.sensor_type = 'motion'", motor.id)
      # elsif sensor_type == 'sound'
      #   # If sound data is significantly higher or lower than usual, comment about it

      elsif sensor_type == 'weather' && data.precipProbability > 0.7
        !Input.joins(sensor: [brain: :motor]).where("motors.id = ? and sensors.sensor_type = 'weather' and inputs.data ~ '\"precipProbability\"=>(1|0\\.[5-9])'", motor.id).exists?
        # We haven't seen precipitation probabilities above 0.5 yet, and now suddenly it's at 0.7
        # so tweet about how it's going to rain
        twitter_client.update("When does it rain money? When there is change in the weather!")
      end
    end
  end
end

# Sample tweet data
# "{\"created_at\":\"Sat Oct 16 17:07:46 +0000 2010\",\"id\":27558893223,\"id_str\":\"27558893223\",\"text\":\"Ruby is the best programming language for hiding the ugly bits.\",\"source\":\"<a href=\\\"http://www.echofon.com/\\\" rel=\\\"nofollow\\\">Echofon</a>\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"user\":{\"id\":7505382,\"id_str\":\"7505382\",\"name\":\"Erik Michaels-Ober\",\"screen_name\":\"sferik\",\"location\":\"Prussia\",\"description\":\"Gemsbok\",\"url\":null,\"entities\":{\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":4884,\"friends_count\":548,\"listed_count\":287,\"created_at\":\"Mon Jul 16 12:59:01 +0000 2007\",\"favourites_count\":11025,\"utc_offset\":7200,\"time_zone\":\"Berlin\",\"geo_enabled\":true,\"verified\":false,\"statuses_count\":15212,\"lang\":\"en\",\"contributors_enabled\":false,\"is_translator\":false,\"is_translation_enabled\":false,\"profile_background_color\":\"000000\",\"profile_background_image_url\":\"http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png\",\"profile_background_image_url_https\":\"https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png\",\"profile_background_tile\":false,\"profile_image_url\":\"http://pbs.twimg.com/profile_images/511430750898376704/GnYJ7Ug2_normal.jpeg\",\"profile_image_url_https\":\"https://pbs.twimg.com/profile_images/511430750898376704/GnYJ7Ug2_normal.jpeg\",\"profile_banner_url\":\"https://pbs.twimg.com/profile_banners/7505382/1410514872\",\"profile_link_color\":\"201040\",\"profile_sidebar_border_color\":\"000000\",\"profile_sidebar_fill_color\":\"DDEEF6\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":false,\"follow_request_sent\":false,\"notifications\":false},\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":2,\"favorite_count\":4,\"entities\":{\"hashtags\":[],\"symbols\":[],\"urls\":[],\"user_mentions\":[]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"}" 
